require "spec_helper"

describe RedboothRuby::Subtask, vcr: 'subtasks' do
  include_context 'authentication'

  let(:create_params) do
    { task_id: 2,
      name: 'new created subtask',
      resolved: 'false' }
  end
  let(:new_record) { client.subtask(:create, create_params) }
  let(:endpoint) { 'subtasks' }
  let(:subtask) do
    client.subtask(:show, id: 1)
  end

  describe "#initialize" do
    subject { subtask }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'Perrea, perrea' }
    it { expect(subject.task_id).to eql 1 }
    it { expect(subject.resolved).to eql true }
  end

  describe ".show" do
    subject { subtask }

    it "makes a new GET request using the correct API endpoint to receive a specific subtask" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "#{endpoint}/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'Perrea, perrea' }
    it { expect(subject.task_id).to eql 1 }
  end

  describe ".update" do
    subject { client.subtask(:update, id: 2, name: 'new test name') }

    it "makes a new PUT request using the correct API endpoint to receive a specific subtask" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "#{endpoint}/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new test name' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_record }

    it "makes a new POST request using the correct API endpoint to create a specific subtask" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, endpoint, create_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new created subtask' }
    it { expect(subject.task_id).to eql 2 }
    it { expect(subject.resolved).to eql false }
  end

  describe ".delete" do
    subject { client.subtask(:delete, id: new_record.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific subtask" do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "#{endpoint}/#{new_record.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.subtask(:index, task_id: 2) }

    it "makes a new GET request using the correct API endpoint to receive subtasks collection" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, endpoint, { task_id: 2 }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end
end
