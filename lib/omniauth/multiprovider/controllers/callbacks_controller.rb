module OmniAuth
  module MultiProvider
    class CallbacksController < Devise::OmniauthCallbacksController
      # TODO: this looks like a good candidate for using method_missing
      Devise.omniauth_providers.each do |provider_name|
        provider_class = begin
          "OmniAuth::Provider::#{provider_name.to_s.camelize}".constantize
        rescue NameError
          OmniAuth::Provider::Generic
        end
        handler = provider_class.new.request_handler
        define_method provider_name do
          instance_exec &handler
        end
      end
    end
  end
end
