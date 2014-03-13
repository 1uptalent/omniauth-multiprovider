module OmniAuth
  module Provider
    class Facebook < Generic

      def self.authenticate(resource, authentication, omniauth_data)
        access_token = omniauth_data.credentials.token
        fb_user = FbGraph::User.me(access_token).fetch
        return nil unless fb_user.identifier == omniauth_data.uid
        authentication.update!(access_token: access_token)
        resource
      end
    end
  end
end
