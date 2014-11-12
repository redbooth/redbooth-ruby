# Encoding: utf-8
require "spec_helper"

describe RedboothRuby::File, vcr: 'files' do
  include_context 'authentication'

  let(:create_params) do
    { project_id: 2,
      backend: 'redbooth',
      asset: File.open("#{File.dirname(__FILE__)}/../fixtures/hola.txt") }
  end
  let(:new_record) { client.file(:create, create_params) }
  let(:endpoint) { 'files' }
  let(:file) do
    client.file(:show, id: 1)
  end

  describe "#initialize" do
    subject { file }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql "Reports" }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.parent_id).to eql nil }
    it { expect(subject.pinned).to eql false }
  end

  describe ".show" do
    subject { file }

    it "makes a new GET request using the correct API endpoint to receive a specific file" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "#{endpoint}/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql "Reports" }
    it { expect(subject.project_id).to eql 2 }
  end

  describe ".update" do
    subject { client.file(:update, id: 2, name: 'new_name.txt') }

    it "makes a new PUT request using the correct API endpoint to receive a specific file" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "#{endpoint}/2", { name: 'new_name.txt' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new_name.txt' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_record }
    let(:asset_params) {
      { asset_attrs: { name: "hola.txt", local_path: "#{File.dirname(__FILE__)}/../fixtures/hola.txt"} }
    }

    it "makes a new POST request using the correct API endpoint to create a specific file" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, endpoint, create_params.merge(asset_params) , { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'hola.txt' }
    it { expect(subject.backend).to eql 'redbooth' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.user_id).to eql 1 }
  end

  describe ".delete" do
    subject { client.file(:delete, id: new_record.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific comment" do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "#{endpoint}/#{new_record.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.file(:index, project_id: 1) }

    it "makes a new GET request using the correct API endpoint to receive comments collection" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, endpoint, {project_id: 1}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end
end
