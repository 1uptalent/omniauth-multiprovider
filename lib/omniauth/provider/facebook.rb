module OmniAuth
  module Provider
    class Facebook < Abstract

      def self.init
        OmniAuth::MultiProvider::CallbacksController.add_callback(:facebook) do
          resource = OmniAuth::Provider::Facebook.find_from_oauth(request.env['omniauth.auth'], send(OmniAuth::MultiProvider::current_resource))
          if resource.persisted?
            sign_in_and_redirect resource, event: :authentication #this will throw if resource is not activated
            set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
          else
            session["devise.facebook_data"] = auth
            redirect_to send("new_#{OmniAuth::MultiProvider::resource_mapping}_registration_url")
          end
        end
      end

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
