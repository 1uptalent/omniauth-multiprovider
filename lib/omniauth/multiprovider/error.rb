module OmniAuth
  module MultiProvider
    class Error < RuntimeError
    end

    class AlreadyBoundError < Error
      def initialize(bound_to)
        @bound_to = bound_to
      end

      attr_reader :bound_to
    end
  end
end
