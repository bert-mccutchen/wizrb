# frozen_string_literal: true

RSpec.describe Wizrb::Lighting::Events::SetSpeedEvent do
  subject(:event) { described_class.new(value) }

  context 'with valid value' do
    let(:value) { described_class::MAX_VALUE - described_class::MIN_VALUE }

    it 'is an instance of Wizrb::Shared::Events::Base' do
      expect(event).to be_a(Wizrb::Shared::Events::Base)
    end

    it 'does not raise an error' do
      expect { event }.not_to raise_error
    end

    it 'sets the speed param' do
      expect(event.params).to eq({ speed: value })
    end
  end

  context 'with value less than min' do
    let(:value) { described_class::MIN_VALUE - 1 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with value greater than max' do
    let(:value) { described_class::MAX_VALUE + 1 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end
end
