require "spec_helper"

describe Redbooth::Organziation, vcr: 'organization' do
  include_context 'authentication'

  let(:create_organization_params) do
    { name: 'new Organziation' }
  end
  let(:new_organization) { client.organization(:create, create_task_params.merge(session: session)) }
  let(:organization) do
    client.organization(:show, id: 1)
  end

  describe "#initialize" do
    subject { organization }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'new Organziation' }
    it { expect(subject.description).to eql 'The ships hung in the sky in much the same way that bricks don\'t.' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.assigned_id).to eql 8 }
    it { expect(subject.due_on).to eql '2014-11-04' }
  end

  describe ".show" do
    subject { organization }

    it "makes a new GET request using the correct API endpoint to receive a specific organization" do
      expect(Redbooth).to receive(:request).with(:get, nil, "organizations/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'new Organziation' }
    it { expect(subject.description).to eql 'The ships hung in the sky in much the same way that bricks don\'t.' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.assigned_id).to eql 8 }
  end

  describe ".update" do
    subject { client.organization(:update, id: 2, name: 'new test name') }

    it "makes a new PUT request using the correct API endpoint to receive a specific organization" do
      expect(Redbooth).to receive(:request).with(:put, nil, "organizations/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new test name' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_organization }

    it "makes a new POST request using the correct API endpoint to create a specific organization" do
      expect(Redbooth).to receive(:request).with(:post, nil, "organizations", create_organization_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new created organization' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.task_list_id).to eql 3 }
  end

  describe ".delete" do
    subject { client.organization(:delete, id: new_organization.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific organization" do
      expect(Redbooth).to receive(:request).with(:delete, nil, "organizations/#{new_organization.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.organization(:index) }

    it "makes a new PUT request using the correct API endpoint to receive a specific organization" do
      expect(Redbooth).to receive(:request).with(:get, nil, "organizations", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql Redbooth::Request::Collection }
  end
end
