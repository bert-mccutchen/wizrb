# frozen_string_literal: true

RSpec.describe Wizrb::Shared::Events::PowerEvent do
  subject(:event) { described_class.new(value) }

  context 'with valid value' do
    let(:value) { true }

    it 'does not raise an error' do
      expect { event }.not_to raise_error
    end

    it 'sets the state param' do
      expect(event.params).to eq({ state: value })
    end
  end

  context 'with invalid value' do
    let(:value) { 0 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end
end
