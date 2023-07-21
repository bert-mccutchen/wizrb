# frozen_string_literal: true

RSpec.describe Wizrb::Lighting::Events::SetRgbEvent do
  subject(:event) { described_class.new(red, green, blue) }

  context 'with valid values' do
    let(:red) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:green) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:blue) { described_class::MAX_VALUE - described_class::MIN_VALUE }

    it 'is an instance of Wizrb::Shared::Events::Base' do
      expect(event).to be_a(Wizrb::Shared::Events::Base)
    end

    it 'does not raise an error' do
      expect { event }.not_to raise_error
    end

    it 'sets the r, g, and b params' do
      expect(event.params).to eq({ r: red, g: green, b: blue })
    end
  end

  context 'with red value less than min' do
    let(:red) { described_class::MIN_VALUE - 1 }
    let(:green) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:blue) { described_class::MAX_VALUE - described_class::MIN_VALUE }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with red value greater than max' do
    let(:red) { described_class::MAX_VALUE + 1 }
    let(:green) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:blue) { described_class::MAX_VALUE - described_class::MIN_VALUE }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with green value less than min' do
    let(:red) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:green) { described_class::MIN_VALUE - 1 }
    let(:blue) { described_class::MAX_VALUE - described_class::MIN_VALUE }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with green value greater than max' do
    let(:red) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:green) { described_class::MAX_VALUE + 1 }
    let(:blue) { described_class::MAX_VALUE - described_class::MIN_VALUE }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with blue value less than min' do
    let(:red) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:green) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:blue) { described_class::MIN_VALUE - 1 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end

  context 'with blue value greater than max' do
    let(:red) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:green) { described_class::MAX_VALUE - described_class::MIN_VALUE }
    let(:blue) { described_class::MAX_VALUE + 1 }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end
end
