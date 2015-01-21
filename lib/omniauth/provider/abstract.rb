module OmniAuth
  module Provider
    class Abstract < SimpleDelegator

      def initialize(controller)
        super
        @controller = controller
      end

      def handle_request(controller)
        raise "Should be defined by subclasses"
      end

      def self.authenticate_from_oauth(provider_name, omniauth_data)
        auth = MultiProvider::authentication_klass.normalize(omniauth_data)
        access_token = auth.credentials.token
        authentication = MultiProvider.authentication_klass.find_by(provider: provider_name, uid: auth.uid)

        if authentication
          authenticate(authentication.send(MultiProvider::resource_mapping), authentication, auth)
        else
          if auth.info[:email].blank?
            auth.info[:email] = MultiProvider::resource_klass.mock_email(provider_name, auth.uid)
          end
          email = auth.info[:email]

          raise MultiProvider::Error.new 'email_already_registered' if MultiProvider::resource_klass.find_by(email: email)

          resource = MultiProvider::resource_klass.create(
                                         email: email,
                                         password: Devise.friendly_token[0,20]
                                         )

          MultiProvider.authentication_klass.from(auth, resource)

          resource
        end
      end
    end
  end
end
