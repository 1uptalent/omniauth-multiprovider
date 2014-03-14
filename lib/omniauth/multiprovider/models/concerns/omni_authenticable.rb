module OmniAuth
  module MultiProvider

    module OmniAuthenticable
      extend ActiveSupport::Concern

      def self.authenticate_from_params(params)
        resource = nil
        if params[:username].present? && params[:password].present?
          resource = MultiProvider::resource_klass.find_for_database_authentication(email: params[:username])
          resource = nil if resource.nil? || !resource.valid_password?(params[:password])
        end
        if params[:provider].present?
          omniauth_data = {
            provider: params[:provider],
            uid: params[:user_id],
            credentials: {
              token: params[:access_token]
            }
          }
          provider_class = "OmniAuth::Provider::#{params[:provider].camelize}".constantize
          resource = provider_class.authenticate_from_oauth(params[:provider], omniauth_data)
        end
        resource
      end

      included do
        include MultiProvider::EmailMockups

        has_many MultiProvider::authentication_relationship_name, dependent: :destroy, inverse_of: MultiProvider::resource_mapping, autosave: true, class_name: MultiProvider::authentication_klass.name do
          def [](provider)
            find_by(provider: provider)
          end
        end

        omniauth_providers.each do |provider_name|
          begin
            klass = "OmniAuth::Provider::#{provider_name.to_s.camelize}".constantize
          rescue NameError
            klass = OmniAuth::Provider::Generic
          end
          klass.init(provider_name)
        end

      end
    end
  end
end