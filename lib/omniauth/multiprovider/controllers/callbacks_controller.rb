module OmniAuth
  module MultiProvider
    class CallbacksController < Devise::OmniauthCallbacksController
      def self.add_callback(provider, &block)
        self.send :define_method, provider, &block
      end
    end
  end
end