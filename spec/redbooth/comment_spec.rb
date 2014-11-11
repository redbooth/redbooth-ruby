# Encoding: utf-8
require "spec_helper"

describe Redbooth::Comment, vcr: 'comments' do
  include_context 'authentication'

  let(:create_params) do
    { project_id: 2,
      target_type: 'Conversation',
      target_id: 2,
      body: 'new created comment' }
  end
  let(:new_record) { client.comment(:create, create_params) }
  let(:endpoint) { 'comments' }
  let(:comment) do
    client.comment(:show, id: 1)
  end

  describe "#initialize" do
    subject { comment }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.body).to eql "Hey guys. I\’m looking forward to working with you all again. I\’m also pleased to be working with my friend and yoga instructor Marco Fizzulo. This should be straightforward project and I can\’t wait to see what we put together." }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.target_id).to eql 1 }
    it { expect(subject.target_type).to eql 'Conversation' }
    it { expect(subject.is_private).to eql false }
  end

  describe ".show" do
    subject { comment }

    it "makes a new GET request using the correct API endpoint to receive a specific comment" do
      expect(Redbooth).to receive(:request).with(:get, nil, "#{endpoint}/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.body).to eql "Hey guys. I\’m looking forward to working with you all again. I\’m also pleased to be working with my friend and yoga instructor Marco Fizzulo. This should be straightforward project and I can\’t wait to see what we put together." }
    it { expect(subject.project_id).to eql 2 }
  end

  describe ".update" do
    subject { client.comment(:update, id: 24, body: 'new test body') }

    it "makes a new PUT request using the correct API endpoint to receive a specific comment" do
      expect(Redbooth).to receive(:request).with(:put, nil, "#{endpoint}/24", { body: 'new test body' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.body).to eql 'new test body' }
    it { expect(subject.id).to eql 24 }
  end

  describe ".create" do
    subject { new_record }

    it "makes a new POST request using the correct API endpoint to create a specific comment" do
      expect(Redbooth).to receive(:request).with(:post, nil, endpoint, create_params, { session: session }).and_call_original
      subject
    end

    it { expect(subject.body).to eql 'new created comment' }
    it { expect(subject.project_id).to eql 2 }
    it { expect(subject.user_id).to eql 1 }
  end

  describe ".delete" do
    subject { client.comment(:delete, id: new_record.id) }

    it "makes a new DELETE request using the correct API endpoint to delete a specific comment" do
      expect(Redbooth).to receive(:request).with(:delete, nil, "#{endpoint}/#{new_record.id}", {}, { session: session }).and_call_original
      subject
    end
  end

  describe ".index" do
    subject { client.comment(:index, target_type: 'Task', target_id: 1) }

    it "makes a new GET request using the correct API endpoint to receive comments collection" do
      expect(Redbooth).to receive(:request).with(:get, nil, endpoint, {target_type: 'Task', target_id: 1}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql Redbooth::Request::Collection }
  end
end
