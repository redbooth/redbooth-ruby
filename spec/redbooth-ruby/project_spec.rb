require "spec_helper"

describe RedboothRuby::Project, vcr: 'project' do
  include_context 'authentication'

  let(:create_params) do
    { name: 'new Project',
      organization_id: 1 }
  end
  let(:new_project) { client.project(:create, create_params.merge(session: session)) }
  let(:endpoint_name) { 'projects' }
  let(:project) do
    client.project(:show, id: 1)
  end

  describe "#initialize" do
    subject { project }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'General' }
    it { expect(subject.permalink).to eql 'general' }
  end

  describe ".show" do
    subject { project }

    it "makes a new GET request using the correct API endpoint to receive a specific project" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "#{endpoint_name}/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'General' }
    it { expect(subject.permalink).to eql 'general' }
  end

  describe ".update" do
    subject { client.project(:update, id: 2, name: 'new test name') }

    it "makes a new PUT request using the correct API endpoint to receive a specific project" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "#{endpoint_name}/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new test name' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_project }

    it "makes a new POST request using the correct API endpoint to create a specific project" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, "#{endpoint_name}", create_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new Project' }
  end

  describe ".delete" do
    subject { client.project(:delete, id: new_project.id) }
    before { allow_any_instance_of(RedboothRuby::Client).to receive(:sleep) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific project" do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "#{endpoint_name}/#{new_project.id}", {}, { session: session }).at_least(:twice).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.project(:index) }

    it "makes a new PUT request using the correct API endpoint to receive a specific project" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "#{endpoint_name}", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end
end
