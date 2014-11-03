require "spec_helper"

describe Redbooth::Request::Validator do
  let(:info) { Redbooth::Request::Info.new(:get, nil, "random", OpenStruct.new(id: 1)) }
  let(:validator) { Redbooth::Request::Validator.new info }
  let(:response) { OpenStruct.new(body: '{"response":"ok"}', code: 200) }

  describe "#validated_response_for" do
    subject { validator.validated_response_for(response) }

    it { should be_a Redbooth::Request::Response }
    it { expect(subject.data).to eq("response" => "ok") }

    context 'with error code returned' do
      let(:response) { OpenStruct.new(body: '{"error":{"message":"Unauthorized"}}', code: 401) }

      it { expect{subject}.to raise_error(Redbooth::APIError) }
    end
  end
end
