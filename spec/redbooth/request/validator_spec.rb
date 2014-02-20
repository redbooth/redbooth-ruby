require "spec_helper"

describe Redbooth::Request::Validator do
  describe "#validated_data_for" do
    it "validates the data" do
      info = Redbooth::Request::Info.new(:get, nil, "random", OpenStruct.new(id: 1))
      validator = Redbooth::Request::Validator.new info
      response = OpenStruct.new(body: '{"response":"ok"}', code: 200)

      validator.validated_data_for(response).should eq "response" => "ok"
    end
  end
end
