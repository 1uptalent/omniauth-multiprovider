module OmniAuth
  module MultiProvider

    module EmailMockups

      def self.included(base)
        base.extend(ClassMethods)
      end

      def mocked_email?
        email.match /.*@from\-.*\.com$/
      end

      def current_email
        mocked_email? ? '' : email
      end

      module ClassMethods
        def mock_email(provider, nickname)
          "#{nickname}@from-#{provider}.example.com"
        end
      end
    end

  end
end