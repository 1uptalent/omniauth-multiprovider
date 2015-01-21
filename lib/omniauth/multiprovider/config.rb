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
    end
  end
end
