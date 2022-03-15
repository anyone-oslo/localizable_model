# frozen_string_literal: true

require "rails_helper"

describe Localization, type: :model do
  let(:localization) { create(:localization) }

  it { is_expected.to belong_to(:localizable).optional }

  describe ".locales" do
    subject { described_class.locales }

    before do
      create(:localization, locale: "en")
      create(:localization, locale: "nb")
    end

    it { is_expected.to match(%w[en nb]) }
  end

  describe ".names" do
    subject { described_class.names }

    before do
      create(:localization, name: "title")
      create(:localization, name: "body")
    end

    it { is_expected.to match(%w[body title]) }
  end

  describe "#to_s" do
    subject { localization.to_s }

    context "when value is nil" do
      let(:localization) { create(:localization, value: nil) }

      it { is_expected.to eq("") }
    end

    context "when value is set" do
      let(:localization) { create(:localization, value: "Hello world") }

      it { is_expected.to eq("Hello world") }
    end
  end

  describe "#empty?" do
    subject { localization.empty? }

    context "when value is empty" do
      let(:localization) { create(:localization, value: nil) }

      it { is_expected.to be(true) }
    end

    context "when value is blank" do
      let(:localization) { create(:localization, value: "") }

      it { is_expected.to be(true) }
    end

    context "when value is set" do
      let(:localization) { create(:localization, value: "Hello world") }

      it { is_expected.to be(false) }
    end
  end

  describe "#translate" do
    before do
      create(:localization,
             locale: "fr",
             localizable: localization.localizable,
             value: "Bonjour tout le monde")
    end

    let(:fr_translation) { localization.translate("fr").to_s }
    let(:en_translation) { localization.translate("en").to_s }

    specify do
      expect(fr_translation).to eq("Bonjour tout le monde")
    end

    specify do
      expect(en_translation).not_to eq("Bonjour tout le monde")
    end
  end
end
