# frozen_string_literal: true

RSpec.describe Wizrb::Shared::Events::RebootEvent do
  subject(:event) { described_class.new }

  it "does not raise an error" do
    expect { event }.not_to raise_error
  end
end
