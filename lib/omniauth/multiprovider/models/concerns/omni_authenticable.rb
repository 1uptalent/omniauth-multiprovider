
module OmniAuth
  module MultiProvider

    module OmniAuthenticable
      extend ::ActiveSupport::Concern

      included do
        include MultiProvider::EmailMockups

        class << self
          def _oamp
            @_omniauth_multiprovider_config ||= OmniAuth::MultiProvider::Config.new
          end

          def from_oauth(omniauth_data, signed_in_resource=nil)
            auth = _oamp.authentication_klass.normalize(omniauth_data)
            provider_name = auth.provider
            access_token = auth.credentials.token
            authentication = _oamp.authentication_klass.find_by(provider: provider_name, uid: auth.uid)

            resource = authentication.try :resource

            if resource and signed_in_resource
              signed_in_resource.oauth_already_bound resource, auth
              return signed_in_resource
            end
            unless resource
              if auth.info[:email].blank?
                auth.info[:email] = mock_email(provider_name, auth.uid)
              end
              email = auth.info[:email]

              raise OmniAuth::MultiProvider::EmailTakenError if find_by(email: email)

              resource = signed_in_resource || new(email: email, password: Devise.friendly_token[0,20])

              _oamp.authentication_klass.from(auth, resource)

            end
            resource
          end
        end

        # Handler for the case when there is already an Authentication
        def oauth_already_bound(other, oauth_data)
          return self if self == other # do nothing if its own authentication
          # raise error if the oauth data is bound to another resource
          raise MultiProvider::AlreadyBoundError.new signed_in_resource, new_resource
        end

        has_many _oamp.authentication_relationship_name,
          dependent: :destroy,
          inverse_of: :resource,
          as: :resource,
          autosave: true,
          class_name: _oamp.authentication_klass.name do
            def [](provider)
              find_by(provider: provider)
            end
          end
      end
    end
  end
end
