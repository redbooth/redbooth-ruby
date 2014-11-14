require "spec_helper"

describe RedboothRuby::Operations::Search, vcr: 'search' do
  include_context 'authentication'

  let(:search_params) do
    { project_id: 2,
      name: 'new created note',
      content: 'bla bla bla' }
  end
  let(:endpoint) { 'search' }

  describe ".index" do
    subject { client.search(query: 'task') }

    it "makes a new GET request using the correct API endpoint to receive notes collection" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, endpoint, { query: 'task' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
    it { expect(subject.all.first).to be_a RedboothRuby::Base }
  end
end
