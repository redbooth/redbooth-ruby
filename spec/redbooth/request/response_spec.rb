require "spec_helper"

describe Redbooth::Request::Response do
  let(:headers) { {} }
  let(:status) { 200 }
  let(:body) { '{"response":"ok"}' }
  let(:response) { Redbooth::Request::Response.new(body: body,
                                                   status: status,
                                                   headers: headers) }

  describe "#initialize" do
    subject { response }

    it { should be_a Redbooth::Request::Response }
    it { expect(subject.data).to eq("response" => "ok") }
    it { expect(subject.body).to eq(body) }
    it { expect(subject.headers).to eq(headers) }
    it { expect(subject.status).to eq(status) }

    context 'with wrong json body' do
      let(:body) { '<html> asdfasdf </html>' }

      it { expect(subject.data).to be_empty }
    end

    context 'with empty body' do
      let(:body) { nil }

      it { expect(subject.data).to be_empty }
    end
  end
end
