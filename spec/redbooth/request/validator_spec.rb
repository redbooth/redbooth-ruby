require "spec_helper"

describe Redbooth::Request::Validator do
  let(:info) { Redbooth::Request::Info.new(:get, nil, "random", OpenStruct.new(id: 1)) }
  let(:validator) { Redbooth::Request::Validator.new info }
  let(:headers) { {} }
  let(:response) { OpenStruct.new(body: '{"response":"ok"}', status: 200, headers: headers) }

  describe "#validated_response_for" do
    subject { validator.validated_response_for(response) }

    it { should be_a Redbooth::Request::Response }
    it { expect(subject.data).to eq("response" => "ok") }

    context 'where 401 status code returned' do
      let(:response) { OpenStruct.new(body: '{"error":{"message":"Unauthorized"}}', status: 401, headers: headers) }

      it { expect{subject}.to raise_error(Redbooth::AuthenticationError) }

      context 'where token was expired' do
        before { headers['WWW-Authenticate'] = %{Bearer realm="Doorkeeper", error="invalid_token", error_description="The access token was expired"} }

        it { expect{subject}.to raise_error(Redbooth::OauhtTokenExpired) }
      end

      context 'where token was revoked' do
        before { headers['WWW-Authenticate'] = %{Bearer realm="Doorkeeper", error="invalid_token", error_description="The access token was revoked"} }

        it { expect{subject}.to raise_error(Redbooth::OauhtTokenRevoked) }
      end
    end

    context 'where 500 status code returned' do
      let(:response) { OpenStruct.new(body: '{"error":{"message":"Something went wrong"}}', status: 500, headers: headers) }

      it { expect{subject}.to raise_error(Redbooth::APIError) }
    end

    context 'where 404 status code returned' do
      let(:response) { OpenStruct.new(body: '{"error":{"message":"There is no task with the given id in the system"}}', status: 404, headers: headers) }

      it { expect{subject}.to raise_error(Redbooth::NotFound) }
    end
  end
end
