require "spec_helper"

describe RedboothRuby::Me, vcr: 'me' do
  include_context 'authentication'
  let(:me) { client.me(:show) }
  let(:response) { double(:response, data: {})}

  describe '#initialize' do
    subject { me }

    it { expect(subject.email).to eql('example_frank@redbooth.com') }
    it { expect(subject.id).to eql(1) }
    it { expect(subject.first_name).to eql('Frank') }
    it { expect(subject.last_name).to eql('Kramer') }
  end

  describe '.show' do
    subject { me }

    it 'makes a new GET request using the correct API endpoint to receive a specific user' do
      expect(RedboothRuby).to receive(:request).with(:get, nil, 'me', {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.email).to eql('example_frank@redbooth.com') }
    it { expect(subject.id).to eql(1) }
    it { expect(subject.first_name).to eql('Frank') }
    it { expect(subject.last_name).to eql('Kramer') }
  end

  describe '#update' do
    let(:update_attributes) { { first_name: 'new_first_name' } }
    subject { client.me(:update, update_attributes) }

    it 'makes a new PUT request using the correct API endpoint' do
      expect(RedboothRuby).to receive(:request).with(:put, nil, 'me', update_attributes, { session: session }).and_return(response)
      subject
    end

    context 'integration' do
      after(:each) { client.me(:update, first_name: 'Frank') }

      it { expect(subject.first_name).to eql('new_first_name') }
    end
  end

  describe '#delete' do
    subject { client.me(:delete) }

    it 'makes a new DELETE request using the correct API endpoint' do
      expect(RedboothRuby).to receive(:request).with(:delete, nil, 'me', {}, { session: session })

      subject
    end
  end
end
