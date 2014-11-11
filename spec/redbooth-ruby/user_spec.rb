require "spec_helper"

describe RedboothRuby::User, vcr: 'users' do
  include_context 'authentication'

  let(:user) do
    RedboothRuby::User.show(session: session, id: 1)
  end

  describe "#initialize" do
    subject { user }

    it { expect(subject.email).to eql('example_frank@redbooth.com') }
    it { expect(subject.id).to eql(1) }
    it { expect(subject.first_name).to eql('Frank') }
    it { expect(subject.last_name).to eql('Kramer') }
  end

  describe ".show" do
    subject { RedboothRuby::User.show(session: session, id: 1) }

    it 'makes a new GET request using the correct API endpoint to receive a specific user' do
      expect(RedboothRuby).to receive(:request).with(:get, nil, "users/1", {}, { session: session }).and_call_original
      subject
    end

    it { expect(subject.email).to eql('example_frank@redbooth.com') }
    it { expect(subject.id).to eql(1) }
    it { expect(subject.first_name).to eql('Frank') }
    it { expect(subject.last_name).to eql('Kramer') }
  end
end
