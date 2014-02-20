require "spec_helper"

describe Redbooth::Base do
  describe "#parse_timestamps" do
    context "given #created_time is present" do
      it "creates a Time object" do
        base = Redbooth::Base.new(created_time: 1358300444)
        expect(base.created_time.class).to eql(Time)
      end
    end
  end
end
