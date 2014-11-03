require "spec_helper"

describe Redbooth::User, vcr: 'users' do
  include_context 'authentication'

  let(:user) do
    Redbooth::User.show(session: session, id: 1)
  end

  describe "#initialize" do
    it 'initializes all attributes correctly' do
      expect(user.email).to eql('example_frank@redbooth.com')
      expect(user.id).to eql(1)
      expect(user.first_name).to eql('Frank')
      expect(user.last_name).to eql('Kramer')
    end
  end

  describe ".show" do
    let(:user_show) { Redbooth::User.show(session: session, id: 1) }

    it "makes a new GET request using the correct API endpoint to receive a specific user" do
      expect(Redbooth).to receive(:request).with(:get, nil, "users/1", {}, { session: session }).and_call_original
      user_show
    end
    it 'returns a user with the correct email' do
      expect(user_show.email).to eql('example_frank@redbooth.com')
    end
    it 'returns a user with the correct id' do
      expect(user_show.id).to eql(1)
    end
    it 'returns a user with the correct first_name' do
      expect(user_show.first_name).to eql('Frank')
    end
    it 'returns a user with the correct last_name' do
      expect(user_show.last_name).to eql('Kramer')
    end
  end
end
