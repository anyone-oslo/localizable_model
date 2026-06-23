# frozen_string_literal: true

require "rails_helper"

describe "LocalizablePersistence" do
  describe "when a localization already exists for the same key" do
    let(:page) { Page.create(locale: "en") }

    before do
      page.localizations.load
      Localization.create!(
        localizable_id: page.id,
        localizable_type: "Page",
        name: "name",
        locale: "en",
        value: "First"
      )
    end

    it "upserts instead of raising RecordNotUnique" do
      page.name = "Second"
      expect { page.save! }.not_to raise_error
    end

    it "keeps the latest value" do
      page.update!(name: "Second")
      expect(page.reload.name.to_s).to eq("Second")
    end

    it "does not insert a duplicate" do
      page.update!(name: "Second")
      expect(
        Localization.where(localizable: page, name: "name", locale: "en").count
      ).to eq(1)
    end
  end

  describe "saving multiple locales at once" do
    let(:page) do
      Page.create(name: { "en" => "Title", "nb" => "Tittel" }, locale: "en")
    end

    it "persists the english locale" do
      expect(page.reload.localize("en").name.to_s).to eq("Title")
    end

    it "persists the norwegian locale" do
      expect(page.reload.localize("nb").name.to_s).to eq("Tittel")
    end
  end

  describe "updating an existing localization" do
    let(:page) { Page.create(name: "Title", locale: "en") }

    it "updates the value" do
      page.update!(name: "Changed")
      expect(page.reload.name.to_s).to eq("Changed")
    end

    it "does not insert a duplicate" do
      page.update!(name: "Changed")
      expect(Localization.where(localizable: page, name: "name").count).to eq(1)
    end
  end

  describe "clearing a localization" do
    let(:page) { Page.create(name: "Title", locale: "en") }

    it "removes the localization" do
      page.update!(name: "")
      expect(Localization.where(localizable: page, name: "name")).to be_empty
    end
  end

  describe "reading a localized attribute without assigning a locale" do
    let(:page) { Page.new }

    before do
      page.name?
      page.save!
    end

    it "does not report a blank locale" do
      expect(page.locales).to eq([])
    end

    it "does not persist a phantom localization" do
      expect(Localization.where(localizable: page)).to be_empty
    end
  end
end
