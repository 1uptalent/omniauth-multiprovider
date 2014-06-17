module OmniAuth
  module MultiProvider

    module EmailMockups

      def self.included(base)
        base.extend(ClassMethods)
      end

      def mocked_email?
        read_attribute(:email).match(/.*@from\-.*\.example$/) != nil
      end

      def mocked_email
        read_attribute(:email)
      end

      def email
        mocked_email? ? nil : read_attribute(:email)
      end

      module ClassMethods
        def mock_email(provider, nickname)
          "#{nickname}@from-#{provider}.example"
        end
      end
    end

  end
end
