module OmniAuth
  module MultiProvider
    class Config
      def authentication_klass
        Authentication
      end

      def resource_klass
        User
      end

      def resource_mapping
        :user
      end

      def current_resource
        "current_#{resource_mapping}".to_sym
      end

      def authentication_relationship_name
        :authentications
      end

      # Invoked when an authentication exists but there is already a signed in resource.
      # Must return a Proc (or another object responding to call).
      # The returned object will be invoked with
      def already_bound_handler
        lambda do |new_resource, signed_in_resource, omniauth_data|
          return if new_resource == signed_in_resource
          raise MultiProvider::AlreadyBoundError.new new_resource
        end
      end
    end
  end
end
