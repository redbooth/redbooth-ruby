require "spec_helper"

describe RedboothRuby::Task, vcr: 'tasks' do
  include_context 'authentication'

  let(:create_task_params) do
    { project_id: 2,
      name: 'new created task',
      task_list_id: 3 }
  end
  let(:new_task) { RedboothRuby::Task.create(create_task_params.merge(session: session)) }
  let(:task) do
    RedboothRuby::Task.show(session: session, id: 1)
  end

  describe "#initialize" do
    subject { task }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.name).to eql 'Register all EarthworksYoga TLDs' }
    it { expect(subject.description).to eql 'The ships hung in the sky in much the same way that bricks don\'t.' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.assigned_id).to eql 8 }
    it { expect(subject.due_on).to eql '2014-11-04' }
  end

  describe ".show" do
    it "makes a new GET request using the correct API endpoint to receive a specific task" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "tasks/1", {}, { session: session }).and_call_original
      task
    end
    it 'returns a task with the correct name' do
      expect(task.name).to eql('Register all EarthworksYoga TLDs')
    end
    it 'returns a task with the correct id' do
      expect(task.id).to eql(1)
    end
    it 'returns a task with the correct project_id' do
      expect(task.project_id).to eql(2)
    end
    it 'returns a task with the correct assigned_id' do
      expect(task.assigned_id).to eql(8)
    end
  end

  describe ".update" do
    subject { RedboothRuby::Task.update(session: session, id: 2, name: 'new test name') }

    it "makes a new PUT request using the correct API endpoint to receive a specific task" do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "tasks/2", { name: 'new test name' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new test name' }
    it { expect(subject.id).to eql 2 }
  end

  describe ".create" do
    subject { new_task }

    it "makes a new POST request using the correct API endpoint to create a specific task" do
      expect(RedboothRuby).to receive(:request).with(:post, nil, "tasks", create_task_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.name).to eql 'new created task' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.task_list_id).to eql 3 }
  end

  describe ".delete" do
    subject { RedboothRuby::Task.delete(session: session, id: new_task.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific task" do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "tasks/#{new_task.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { RedboothRuby::Task.index(session: session) }

    it "makes a new PUT request using the correct API endpoint to receive a specific task" do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "tasks", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end
end
