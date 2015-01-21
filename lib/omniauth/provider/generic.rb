module OmniAuth
  module Provider
    class Generic < Abstract

      def handle_request(controller)
        auth = controller.request.env['omniauth.auth']
        provider_name = auth['provider_name']
        resource = controller.resource_class.find_from_oauth auth, controller.signed_in_resource
        if resource.persisted?
          controller.sign_in_and_redirect resource, event: :authentication #this will throw if resource is not activated
          controller.set_flash_message(:notice, :success, kind: provider_name.to_s.camelize) if is_navigational_format?
        else
          controller.session["devise.#{provider_name}_data"] = auth.except('extra')
          controller.redirect_to send("new_#{OmniAuth::MultiProvider::resource_mapping}_registration_url")
        end
      end
    end
  end
end
