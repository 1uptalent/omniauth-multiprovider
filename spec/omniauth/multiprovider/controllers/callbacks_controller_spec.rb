require 'spec_helper'

        # Devise.omniauth_providers.each do |provider_name|
        #   begin
        #     klass = "OmniAuth::Provider::#{provider_name.to_s.camelize}".constantize
        #   rescue NameError
        #     klass = OmniAuth::Provider::Generic
        #   end
        #   klass.init(provider_name)
        # end

describe 'OmniAuth::MultiProvider::CallbacksController' do
  it 'defines methods for omniauth providers' do
    Devise.omniauth :foo
    Devise.omniauth :bar
    allow(OmniAuth::MultiProvider).to receive(:resource_klass) { Class.new }
    methods = OmniAuth::MultiProvider::CallbacksController.action_methods
    expect(methods).to include 'foo'
    expect(methods).to include 'bar'
  end

end
