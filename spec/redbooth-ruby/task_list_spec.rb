require "spec_helper"

describe RedboothRuby::TaskList, vcr: 'task_lists' do
  include_context 'authentication'

  let(:create_task_list_params) do
    { project_id: 1,
      name: 'new created task_list' }
  end
  let(:new_task_list) { RedboothRuby::TaskList.create(create_task_list_params.merge(session: session)) }
  let(:task_list) do
    RedboothRuby::TaskList.show(session: session, id: 2)
  end

  describe "#initialize" do
    subject { task_list }

    it { expect(subject.id).to eql 2 }
    it { expect(subject.name).to eql 'Register all EarthworksYoga TLDs' }
    it { expect(subject.project_id).to eql 1 }
  end

  describe ".show" do
    it "makes a new GET request using the correct API endpoint to receive a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "task_lists/1", {}, { session: session }).and_call_original
      task
    end
    it 'returns a task_list with the correct name' do
      expect(task_list.name).to eql('Register all EarthworksYoga TLDs')
    end
    it 'returns a task_list with the correct id' do
      expect(task_list.id).to eql(1)
    end
    it 'returns a task_list with the correct project_id' do
      expect(task_list.project_id).to eql(2)
    end
    it 'returns a task_list with the correct archived' do
      expect(task_list.archived).to eql(false)
    end
  end

  describe ".update" do
    subject { RedboothRuby::TaskList.update(session: session, id: 2, name: 'new test name') }

    it "makes a new PUT request using the correct API endpoint to receive a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "task_lists/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new test name' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_task_list }

    it "makes a new POST request using the correct API endpoint to create a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, "task_lists", create_task_list_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new created task' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.archived).to eql false }
  end

  describe ".delete" do
    subject { RedboothRuby::TaskList.delete(session: session, id: new_task_list.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "task_lists/#{new_task_list.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { RedboothRuby::TaskList.index(session: session) }

    it "makes a new PUT request using the correct API endpoint to receive a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "task_lists", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end

  describe '.medatada' do
    subject { task_list.metadata }

    it "makes a new PUT request using the correct API endpoint to receive a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "metadata", { target_type: 'TaskList', target_id: task_list.id }, { session: session }).and_call_original
      subject
    end

    it { expect(subject).to be_a Hash }
    it { expect(subject).to be_empty }
  end

  describe '.medatada=' do
    subject { task_list.metadata = { 'new' => 'metadata' } }

    it "makes a new PUT request using the correct API endpoint to receive a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, "metadata", { target_type: 'TaskList', target_id: task_list.id, metadata: { 'new' => 'metadata' } }, { session: session }).and_call_original
      subject
    end

    it { expect(subject).to be_a Hash }
    it { expect(subject).to include 'new' }
    it { expect(subject['new']).to eql 'metadata' }
  end

  describe '.metadata_merge' do
    before { task_list.metadata = { 'new' => 'metadata', 'other' => 'value' } }
    subject { task_list.metadata_merge( 'other' => 'updated_value') }

    it "makes a new PUT request using the correct API endpoint to receive a specific task_list" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "metadata", { target_type: 'TaskList', target_id: task_list.id, metadata: { 'other' => 'updated_value' } }, { session: session }).and_call_original
      subject
    end

    it { expect(subject).to be_a Hash }
    it { expect(subject).to include 'new' }
    it { expect(subject).to include 'other' }
    it { expect(subject['new']).to eql 'metadata' }
    it { expect(subject['other']).to eql 'updated_value' }
  end
end
