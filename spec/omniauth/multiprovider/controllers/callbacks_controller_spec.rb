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
end
