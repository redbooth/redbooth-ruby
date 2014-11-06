require "spec_helper"

describe Redbooth::Person, vcr: 'person' do
  include_context 'authentication'

  let(:create_params) do
    { project_id: 1,
      user_id: 2 }
  end
  let(:endpoint_name) { 'people' }
  let(:new_person) { client.person(:create, create_person_params.merge(session: session)) }
  let(:person) do
    client.person(:show, id: 1)
  end

  describe "#initialize" do
    subject { person }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.user_id).to eql 2 }
    it { expect(subject.role).to eql 2 }
  end

  describe ".show" do
    subject { person }

    it "makes a new GET request using the correct API endpoint to receive a specific person" do
      expect(Redbooth).to receive(:request).with(:get, nil, "#{endpoint_name}/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.user_id).to eql 2 }
    it { expect(subject.role).to eql 2 }
  end

  describe ".update" do
    subject { client.person(:update, id: 2, role: 1) }

    it "makes a new PUT request using the correct API endpoint to receive a specific person" do
      expect(Redbooth).to receive(:request).with(:put, nil, "#{endpoint_name}/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.role).to eql 1 }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_person }

    it "makes a new POST request using the correct API endpoint to create a specific person" do
      expect(Redbooth).to receive(:request).with(:post, nil, "#{endpoint_name}", create_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.user_id).to eql 2 }
  end

  describe ".delete" do
    subject { client.person(:delete, id: new_person.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific person" do
      expect(Redbooth).to receive(:request).with(:delete, nil, "#{endpoint_name}/#{new_person.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.person(:index) }

    it "makes a new PUT request using the correct API endpoint to receive a specific person" do
      expect(Redbooth).to receive(:request).with(:get, nil, "#{endpoint_name}", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql Redbooth::Request::Collection }
  end
end
