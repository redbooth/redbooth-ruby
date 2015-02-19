require 'spec_helper'

describe RedboothRuby::Person, vcr: 'person' do
  include_context 'authentication'

  let(:create_params) do
    { project_id: 1,
      user_id: 3,
      role: 'participant' }
  end
  let(:endpoint_name) { 'people' }
  let(:new_person) { client.person(:create, create_params.merge(session: session)) }
  let(:person) do
    client.person(:show, id: 1)
  end

  describe '#initialize' do
    subject { person }

    it { expect(subject.id).to eql 1 }
    it { expect(subject.user_id).to eql 1 }
    it { expect(subject.role).to eql 'admin' }
  end

  describe '.show' do
    subject { person }

    it 'makes a new GET request using the correct API endpoint to receive a specific person' do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "#{ endpoint_name }/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.id).to eql 1 }
    it { expect(subject.user_id).to eql 1 }
    it { expect(subject.role).to eql 'admin' }
  end

  describe '.update' do
    subject { client.person(:update, id: 6, role: 'admin') }

    it 'makes a new PUT request using the correct API endpoint to receive a specific person' do
      expect(RedboothRuby).to receive(:request).with(:put, nil, "#{ endpoint_name }/6", { role: 'admin' }, { session: session }).and_call_original
      subject
    end

    it { expect(subject.role).to eql 'admin' }
    it { expect(subject.id).to eql 6 }
  end

  describe '.create' do
    subject { new_person }
    let(:response) { double(:response, data: {} )}

    it 'makes a new POST request using the correct API endpoint to create a specific person' do
      expect(RedboothRuby).to receive(:request).with(:post, nil, endpoint_name, create_params, { session: session }).and_return(response)
      subject
    end

    context 'integration' do
      after { client.person(:delete, id: subject.id) }

      it { expect(subject.user_id).to eql 3 }
    end
  end

  describe '.delete' do
    subject { client.person(:delete, id: new_person.id) }

    it 'makes a new DELETE request using the correct API endpoint to delete a specific person' do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, "#{ endpoint_name }/#{ new_person.id }", {}, { session: session }).and_call_original
      subject
    end
  end

  describe '.index' do
    subject { client.person(:index) }

    it 'makes a new PUT request using the correct API endpoint to receive a specific person' do
      expect(RedboothRuby).to receive(:request).with(:get, nil, endpoint_name, {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.class).to eql RedboothRuby::Request::Collection }
  end
end