# frozen_string_literal: true

RSpec.describe Wizrb::Lighting::State do
  let(:state) { described_class.new }
  let(:response) { JSON.parse(File.read("spec/fixtures/getPilot_on_lighting.json")) }

  before { state.parse!(response) }

  describe "#warm_white" do
    subject { state.warm_white }

    it { is_expected.to eq(255) }
  end

  describe "#cold_white" do
    subject { state.cold_white }

    it { is_expected.to eq(255) }
  end

  describe "#rgb" do
    subject { state.rgb }

    it { is_expected.to eq({red: 255, green: 255, blue: 255}) }
  end

  describe "#color_temp" do
    subject { state.color_temp }

    it { is_expected.to eq(3200) }
  end

  describe "#brightness" do
    subject { state.brightness }

    it { is_expected.to eq(100) }
  end

  describe "#speed" do
    subject { state.speed }

    it { is_expected.to eq(100) }
  end

  describe "#scene" do
    subject { state.scene }

    context "without a scene active" do
      it { is_expected.to be_nil }
    end

    context "with the party scene active" do
      let(:response) { JSON.parse(File.read("spec/fixtures/getPilot_party_lighting.json")) }

      it { is_expected.to eq(:party) }
    end
  end
end
