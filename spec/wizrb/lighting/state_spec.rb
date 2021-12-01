# frozen_string_literal: true

RSpec.describe Wizrb::Lighting::State do
  subject(:state) { described_class.new }

  let(:response) { JSON.parse(File.read('spec/fixtures/getPilot-1.json')) }

  before { state.parse!(response) }

  describe '#brightness' do
    it 'returns the minimum brightness' do
      expect(state.brightness).to eq(10)
    end
  end

  describe '#power' do
    it 'returns the power state' do
      expect(state.power).to be true
    end
  end

  describe '#color_temp' do
    it 'returns the color temperature' do
      expect(state.color_temp).to eq(2000)
    end
  end

  describe '#scene' do
    it 'returns nil when scene is not present' do
      expect(state.scene).to be nil
    end
  end

  describe '#to_s' do
    it 'returns a string representation of the state' do
      expect(state.to_s).to eq('{:state=>true, :temp=>2000, :dimming=>10}')
    end
  end

  describe '#to_json' do
    it 'returns a JSON representation of the state' do
      expect(state.to_json).to eq('{"state":true,"temp":2000,"dimming":10}')
    end
  end
end
