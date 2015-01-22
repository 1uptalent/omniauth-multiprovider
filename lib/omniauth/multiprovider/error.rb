module OmniAuth
  module MultiProvider
    class Error < RuntimeError
    end

    class AlreadyBoundError < Error
      def initialize(current, bound_to)
        @current = current
        @bound_to = bound_to
      end

      def message
        if @current == @bound_to
          'bound_to_same'
        else
          'bound_to_other'
        end
      end

      attr_reader :current, :bound_to
    end

    class EmailTakenError < Error
      def message
        'email_taken'
      end
    end
  end
end
