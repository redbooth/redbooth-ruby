require "spec_helper"

describe Redbooth::User, vcr: 'tasks' do
  include_context 'authentication'

  let(:task) do
    Redbooth::Task.show(session: session, id: 1)
  end

  describe "#initialize" do
    subject { task }

    its(:id) { should eql 1 }
    its(:name) { should eql 'Register all EarthworksYoga TLDs' }
    its(:description) { should eql 'The ships hung in the sky in much the same way that bricks don\'t.' }
    its(:project_id) { should eql 2 }
    its(:assigned_id) { should eql 8 }
    its(:due_on) { should eql '2014-11-04' }
  end

  describe ".show" do
    it "makes a new GET request using the correct API endpoint to receive a specific user" do
      expect(Redbooth).to receive(:request).with(:get, nil, "tasks/1", {}, { session: session }).and_call_original
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
end
