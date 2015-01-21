require 'spec_helper'

describe OmniAuth::MultiProvider::OmniAuthenticable do
  describe '#find_from_oauth' do
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
        actual = User.find_from_oauth authentication.provider, omniauth_data
        expect(expected).to eq actual
      end

      it 'fails if the current user is different' do
        another_user = User.new
        expect do
          User.find_from_oauth authentication.provider, omniauth_data, another_user
        end.to raise_error OmniAuth::MultiProvider::AlreadyBoundError
      end

      it 'fails if the already bound to current user' do
        expect do
          User.find_from_oauth authentication.provider, omniauth_data, user
        end.to raise_error OmniAuth::MultiProvider::Error
      end
    end
  end
end
