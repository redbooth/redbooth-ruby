require "spec_helper"

describe RedboothRuby::ClientOperations::Metadata, vcr: 'metadata' do
  include_context 'authentication'

  let(:search_params) do
    { project_id: 2,
      key: 'new',
      vaue: 'metadata' }
  end
  let(:endpoint) { 'metadata/search' }

  describe ".metadata" do
    subject { client.metadata(search_params) }

    it "makes a new GET request using the correct API endpoint to receive notes collection" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, endpoint, search_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
    it { expect(subject.all.first).to be_a RedboothRuby::Base }
  end
end
