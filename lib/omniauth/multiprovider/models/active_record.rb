require 'omniauth/multiprovider/config'

module OmniAuth
  module MultiProvider
    module ActiveRecord
      def omniauthenticable
        include OmniAuth::MultiProvider::OmniAuthenticable
      end
    end
  end
end

ActiveRecord::Base.extend OmniAuth::MultiProvider::ActiveRecord
