module OmniAuth
  module MultiProvider
    class CallbacksController < Devise::OmniauthCallbacksController

      protected

      def self.create_handler(provider_name)
        provider_class =
          begin
            "OmniAuth::Provider::#{provider_name.to_s.camelize}".constantize
          rescue NameError
            OmniAuth::Provider::Generic
          end
        define_method provider_name do
          memo_name = "@_#{provider_name}"
          provider = instance_variable_get memo_name
          unless provider.present?
            provider = provider_class.new(self)
            instance_variable_set memo_name, provider
          end
          provider.handle_request self
        end
      end

      # TODO: this looks like a good candidate for using method_missing
      Devise.omniauth_providers.each do |provider_name|
        create_handler provider_name
      end
    end
  end
end
