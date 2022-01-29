# frozen_string_literal: true

RSpec.describe Wizrb::Lighting::Events::SetColorTempEvent do
  subject(:event) { described_class.new(value) }

  context 'with valid value' do
    let(:value) { described_class::MAX_VALUE - described_class::MIN_VALUE }

    it 'does not raise an error' do
      expect { event }.not_to raise_error
    end

    it 'sets the temp param' do
      expect(event.params).to eq({ temp: value })
    end
  end

  context 'with value less than min' do
    let(:value) { described_class::MIN_VALUE - 100 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with value greater than max' do
    let(:value) { described_class::MAX_VALUE + 100 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with value not divisible by 100' do
    let(:value) { described_class::MIN_VALUE + 1 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end
end
