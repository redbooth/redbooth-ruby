require "spec_helper"

describe RedboothRuby::Organization, vcr: 'organization' do
  include_context 'authentication'

  let(:create_organization_params) do
    { name: 'new Organization' }
  end
  let(:new_organization) { client.organization(:create, create_organization_params.merge(session: session)) }
  let(:organization) do
    client.organization(:show, id: 1)
  end

  describe "#initialize" do
    subject { organization }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'Design projects' }
    it { expect(subject.permalink).to eql 'design-projects' }
    it { expect(subject.domain).to eql nil }
  end

  describe ".show" do
    subject { organization }

    it "makes a new GET request using the correct API endpoint to receive a specific organization" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "organizations/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'Design projects' }
    it { expect(subject.permalink).to eql 'design-projects' }
    it { expect(subject.domain).to eql nil }
  end

  describe ".update" do
    subject { client.organization(:update, id: 2, name: 'new test name') }

    it "makes a new PUT request using the correct API endpoint to receive a specific organization" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "organizations/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new test name' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_organization }

    it "makes a new POST request using the correct API endpoint to create a specific organization" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, "organizations", create_organization_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new Organization' }
  end

  describe ".delete" do
    subject { client.organization(:delete, id: new_organization.id) }
    before { allow_any_instance_of(RedboothRuby::Client).to receive(:sleep) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific organization" do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "organizations/#{new_organization.id}", {}, { session: session }).twice.and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.organization(:index) }

    it "makes a new PUT request using the correct API endpoint to receive a specific organization" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "organizations", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end
end
