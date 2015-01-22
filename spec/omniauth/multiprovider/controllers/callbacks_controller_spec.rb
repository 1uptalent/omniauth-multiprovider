require 'spec_helper'

describe 'OmniAuth::MultiProvider::CallbacksController' do
  let(:klass) { OmniAuth::MultiProvider::CallbacksController }

  it 'defines methods for omniauth providers' do
    Devise.omniauth :foo
    Devise.omniauth :bar
    methods = klass.action_methods
    expect(methods).to include 'foo'
    expect(methods).to include 'bar'
  end

  describe '#create_handler' do
    it 'creates a method with the handler name' do
      klass.send :create_handler, 'whatever'
      expect(klass.action_methods).to include 'whatever'
    end

    it 'creates a generic handler for unknown providers' do
      expect_any_instance_of(OmniAuth::Provider::Generic).to receive :handle_request
      klass.send :create_handler, 'whatever'
      klass.new.whatever
    end

    it 'creates a custom handler for Facebook' do
      expect_any_instance_of(OmniAuth::Provider::Facebook).to receive :handle_request
      klass.send :create_handler, 'facebook'
      klass.new.facebook
    end
  end

  describe '#handle_request' do
    subject { klass.new }
    let(:request) { ActionDispatch::TestRequest.new }
    let(:response) { ActionDispatch::TestResponse.new }
    before { klass.send :public, :handle_request }
    before { allow(subject).to receive(:devise_mapping) { Devise.mappings[:user]} }
    before do
      subject.instance_variable_set '@_request', request
      subject.instance_variable_set '@_response', response
    end

    context 'when it raises' do
      let(:provider) { double('a provider') }

      context 'MultiProvider errors' do
        let(:error) { OmniAuth::MultiProvider::Error.new 'message_key' }
        before { expect(provider).to receive(:handle_request).and_raise(error) }

        context 'default behavior' do
          it 'does not raise' do
            expect { subject.handle_request provider }.not_to raise_error
          end

          it 'sets the flash[:alert] with an I18N error message' do
            subject.handle_request provider
            expect(subject.flash[:alert]).to match %r{en.devise.callbacks.user.#{error.message}}
          end

          it 'redirects to the remembered url' do
            location = '/foo/bar/baz'
            subject.store_location_for :user, location
            subject.handle_request provider
            expect(response.location).to eq "http://test.host#{location}"
          end
        end

        it 'does raise if the error is not handled' do
          allow(subject).to receive(:handle_provider_error) { false }
          expect { subject.handle_request provider }.to raise_error error
        end
      end

      context 'unexpected errors' do
        let(:unexpected_error) { Class.new(RuntimeError).new("some message") }
        before { expect(provider).to receive(:handle_request).and_raise(unexpected_error) }
        it 're-raises the error by default' do
          expect { subject.handle_request provider }.to raise_error unexpected_error
        end
        it 'does not raise if the error is handled' do
          allow(subject).to receive(:handle_unexpected_error) { true }
          expect { subject.handle_request provider }.not_to raise_error
        end
      end
    end
  end


end
