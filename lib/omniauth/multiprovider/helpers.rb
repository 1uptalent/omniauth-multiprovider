module OmniAuth
  module MultiProvider
    def self.authentication_klass
      Authentication
    end

    def self.resource_klass
      User
    end

    def self.resource_mapping
      :user
    end

    def self.current_resource
      "current_#{resource_mapping}".to_sym
    end

    def self.authentication_relationship_name
      :authentications
    end
  end
end
