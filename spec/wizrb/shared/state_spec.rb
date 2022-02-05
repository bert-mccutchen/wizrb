# frozen_string_literal: true

RSpec.describe Wizrb::Shared::State do
  let(:state) { described_class.new }

  before { state.parse!(response) }

  context 'when device is off' do
    let(:response) { JSON.parse(File.read('spec/fixtures/getPilot_off.json')) }

    describe '#power' do
      subject { state.power }

      it { is_expected.to eq(false) }
    end

    describe '#to_s' do
      subject { state.to_s }

      it { is_expected.to eq('{:state=>false}') }
    end

    describe '#to_json' do
      subject { state.to_json }

      it { is_expected.to eq('{"state":false}') }
    end
  end

  context 'when device is on' do
    let(:response) { JSON.parse(File.read('spec/fixtures/getPilot_on.json')) }

    describe '#power' do
      subject { state.power }

      it { is_expected.to eq(true) }
    end

    describe '#to_s' do
      subject { state.to_s }

      it { is_expected.to eq('{:state=>true}') }
    end

    describe '#to_json' do
      subject { state.to_json }

      it { is_expected.to eq('{"state":true}') }
    end
  end
end
