module OmniAuth
  module Provider
    class Generic < Abstract

      def request_handler
        Proc.new do
          auth = request.env['omniauth.auth']
          provider_name = auth['provider_name']
          resource = resource_class.find_from_oauth provider_name, auth, signed_in_resource
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
