
module OmniAuth
  module MultiProvider

    module OmniAuthenticable
      extend ::ActiveSupport::Concern

      included do
        include OmniAuth::MultiProvider::EmailMockups

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
              attributes = oauth_to_attributes auth
              if signed_in_resource
                signed_in_resource.update_from_oauth attributes, auth
                resource = signed_in_resource
              else
                resource = create_from_oauth attributes, auth
              end
              _oamp.authentication_klass.from(auth, resource)
            end
            resource
          end

          # Can be customized in each model
          def oauth_to_attributes(oauth_data)
            attrs = {
              email: oauth_data.info[:email] || mock_email(oauth_data.provider, oauth_data.uid),
              password: Devise.friendly_token[0,20]
            }
            attrs[:password_confirmation] = attrs[:password]
            return attrs
          end

          # Can be customized in each model
          def create_from_oauth(attributes, signed_in_resource = nil, oauth_data)
            raise OmniAuth::MultiProvider::EmailTakenError if exists?(email: attributes[:email])
            create!(attributes)
          end
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

      # Handler for the case when there is already an Authentication
      # Can be customized in each model
      def oauth_already_bound(other, oauth_data)
        if self == other
          # update
          self.update_from_oauth self.class.oauth_to_attributes(oauth_data), oauth_data
        else
          # raise error if the oauth data is bound to another resource
          raise MultiProvider::AlreadyBoundError.new self, other
        end
      end

      # Handler for the case when a signed_in_resource exists and is being authenticated
      # Can be customized in each model
      def update_from_oauth(new_attrs, oauth)
        unless self.email.blank? || new_attrs[:email] == self.email
          # refusing to change existing email
          new_attrs.delete(:email)
          # but check if someone else is using it anyway
          raise OmniAuth::MultiProvider::EmailTakenError if User.exists?(email: new_attrs[:email])
        end
        self.update!(new_attrs)
      end
    end
  end
end
