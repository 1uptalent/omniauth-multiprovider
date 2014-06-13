module OmniAuth
  module Provider
    class Abstract

      def self.init
      end

      OmniAuth::MultiProvider::resource_klass.send(:include, OmniAuth::MultiProvider::EmailMockups)

      def self.find_from_oauth(provider_name, omniauth_data, signed_in_resource=nil)
        auth = MultiProvider::authentication_klass.normalize(omniauth_data)
        access_token = auth.credentials.token
        authentication = MultiProvider.authentication_klass.find_by(provider: provider_name, uid: auth.uid)

        resource = nil

        if authentication
          if signed_in_resource
            if authentication.resource == signed_in_resource
              raise MultiProvider::Error.new 'already connected'
            else
              raise MultiProvider::Error.new 'already connected with other user'
            end
          end
          resource = authentication.resource
        end
        unless resource
          if auth.info[:email].blank?
            auth.info[:email] = MultiProvider::resource_klass.mock_email(provider_name, auth.uid)
          end
          email = auth.info[:email]

          raise MultiProvider::Error.new 'email_already_registered' if MultiProvider::resource_klass.find_by(email: email)

          resource = signed_in_resource || MultiProvider::resource_klass.new(
                                         email: email,
                                         password: Devise.friendly_token[0,20]
                                         )

          MultiProvider.authentication_klass.from(auth, resource)

        end
        resource
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
