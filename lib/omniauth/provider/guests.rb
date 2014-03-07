module OmniAuth
  module Provider
    class Guests < Abstract

      def self.authenticate(resource, authentication, omniauth_data)
        return nil unless authentication.access_token == omniauth_data.credentials.token
        resource
      end

    end
  end
end
