module OmniAuth
  module Provider
    class Generic < Abstract

      def self.init(provider_name)
        klass = self
        OmniAuth::MultiProvider::CallbacksController.add_callback(provider_name) do
          auth = request.env['omniauth.auth']
          resource = klass.find_from_oauth(provider_name, auth, send(OmniAuth::MultiProvider::current_resource))
          if resource.persisted?
            sign_in_and_redirect resource, event: :authentication #this will throw if resource is not activated
            set_flash_message(:notice, :success, kind: provider_name.to_s.camelize) if is_navigational_format?
          else
            session["devise.#{provider_name}_data"] = auth.except('extra')
            redirect_to send("new_#{OmniAuth::MultiProvider::resource_mapping}_registration_url")
          end
        end
      end

    end
  end
end
