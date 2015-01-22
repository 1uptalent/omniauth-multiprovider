require 'spec_helper'

describe OmniAuth::MultiProvider::OmniAuthenticable do
  describe '#from_oauth' do
    context 'already authenticated' do
      let(:user) do
        u = User.new
        u.save validate: false
        u
      end
      let(:authentication) do
        Authentication.create(resource: user, provider: 'test', uid: '123')
      end
      let(:omniauth_data) do
        #https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
        {
          provider: authentication.provider,
          uid: authentication.uid,
          credentials: { token: 'foo' }
        }
      end

      it 'returns the existing user' do
        expected = user
        actual = User.from_oauth omniauth_data
        expect(expected).to eq actual
      end

      it 'fails if the current user is different' do
        another_user = User.new
        expect do
          User.from_oauth omniauth_data, another_user
        end.to raise_error OmniAuth::MultiProvider::AlreadyBoundError
      end

      it 'succeeds if already bound to current user' do
        expect do
          User.from_oauth omniauth_data, user
        end.not_to raise_error
      end
    end
  end

  describe '#oauth_to_attributes' do
    it 'returns email, password and password_confirmation' do
      oauth = {provider: 'foo', info: { email: 'some_email' } }.to_hashugar
      attrs = User.oauth_to_attributes oauth
      expect(attrs.keys).to match [:email, :password, :password_confirmation]
    end

    it 'returns a mock email when oauth data does not have it' do
      oauth = {provider: 'foo', info: {} }.to_hashugar
      email = User.oauth_to_attributes(oauth)[:email]
      expect(email).to match /@from-foo\.example$/
    end

    it 'returns the oauth email if present' do
      oauth = {provider: 'foo', info: {email: 'smith@example.com'} }.to_hashugar
      email = User.oauth_to_attributes(oauth)[:email]
      expect(email).to eq 'smith@example.com'
    end
  end

  describe '#update_from_oauth' do

  end
end
