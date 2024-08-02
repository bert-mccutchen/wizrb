# frozen_string_literal: true

RSpec.describe Wizrb::Shared::Events::Base do
  describe "#to_json" do
    subject { event.to_json }

    context "with only the method" do
      let(:event) { described_class.new(method: "test") }

      it { is_expected.to eq('{"method":"test","params":{}}') }
    end

    context "with method and params" do
      let(:params) { {a: "foo", b: {c: "bar"}} }
      let(:event) { described_class.new(method: "test", params: params) }

      it { is_expected.to eq('{"method":"test","params":{"a":"foo","b":{"c":"bar"}}}') }
    end
  end
end
