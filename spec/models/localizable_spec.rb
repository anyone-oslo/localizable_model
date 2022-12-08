# frozen_string_literal: true

require "rails_helper"

describe "Localizable" do
  describe ".localized" do
    subject { Page.localized("nb") }

    let!(:norwegian_page) { Page.create(name: "Test", locale: "nb") }
    let!(:english_page) { Page.create(name: "Test", locale: "en") }

    it { is_expected.to include(norwegian_page) }
    it { is_expected.not_to include(english_page) }
  end

  describe ".locales" do
    subject { localizable.locales }

    let(:localizable) do
      Page.create(
        body: { "en" => "My test page", "nb" => "Testside" },
        locale: "en"
      )
    end

    it { is_expected.to match(%w[en nb]) }
  end

  describe "#any_locale" do
    subject { page.any_locale.body }

    context "when attribute exists in current language" do
      let(:page) do
        Page.create(body: { "en" => "My test page", "nb" => "Testside" },
                    locale: "en")
      end

      it { is_expected.to eq("My test page") }

      it "responds to .body?" do
        expect(page.any_locale.body?).to be(true)
      end
    end

    context "when attribute exists in other language" do
      let(:page) do
        Page.create(body: { "nb" => "Testside" },
                    locale: "en")
      end

      it { is_expected.to eq("Testside") }

      it "responds to .body?" do
        expect(page.any_locale.body?).to be(true)
      end
    end

    context "when attribute doesn't exist" do
      let(:page) do
        Page.create(locale: "en")
      end

      it { is_expected.to eq("") }

      it "responds to .body?" do
        expect(page.any_locale.body?).to be(false)
      end
    end
  end

  describe "#localized_attributes" do
    subject { page.localized_attributes }

    let(:page) do
      Page.create(body: { "en" => "My test page", "nb" => "Testside" })
    end
    let(:attributes) do
      {
        "body" => { "en" => "My test page", "nb" => "Testside" },
        "name" => { "en" => nil, "nb" => nil }
      }
    end

    it { is_expected.to match(attributes) }
  end

  describe "setting multiple locales" do
    let(:page) do
      Page.create(
        body: { "en" => "My test page", "nb" => "Testside" },
        locale: "en"
      )
    end

    specify { expect(page.body?).to be(true) }
    specify { expect(page.body.to_s).to eq("My test page") }
    specify { expect(page.localize("nb").body.to_s).to eq("Testside") }
    specify { expect(page.locales).to match(%w[en nb]) }

    context "when removing unnecessary locales" do
      before do
        page.update(body: "")
        page.reload
      end

      specify { expect(page.locales).to match(["nb"]) }
    end
  end

  describe "returns a blank Localization for uninitialized columns" do
    let(:page) { Page.new }

    specify { expect(page.body?).to be(false) }
    specify { expect(page.body).to be_a(String) }
  end

  describe "with a body" do
    let(:page) { Page.create(body: "My test page", locale: "en") }

    specify { expect(page.body?).to be(true) }
    specify { expect(page.body).to be_a(String) }
    specify { expect(page.body.to_s).to eq("My test page") }

    it "is changed when saved" do
      page.update(body: "Hi")
      page.reload
      expect(page.body.to_s).to eq("Hi")
    end

    it "responds with false when body is nil" do
      page.body = nil
      expect(page.body?).to be(false)
    end

    it "removes the localization when nilified" do
      page.update(body: nil)
      page.reload
      expect(page.body?).to be(false)
    end
  end
end
