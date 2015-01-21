require 'omniauth/multiprovider'
require 'omniauth/multiprovider/models/active_record'

autoload :Authentication,             'omniauth/multiprovider/models/authentication'
module OmniAuth
  module MultiProvider
    autoload :CallbacksController,        'omniauth/multiprovider/controllers/callbacks_controller'
    autoload :OmniAuthenticable,          'omniauth/multiprovider/models/concerns/omni_authenticable'
    autoload :EmailMockups,               'omniauth/multiprovider/models/email_mockups'
    autoload :Error,                      'omniauth/multiprovider/error'
    autoload :AlreadyBoundError,          'omniauth/multiprovider/error'
  end
  module Provider
    autoload :Abstract,                   'omniauth/provider/abstract'
    autoload :Generic,                    'omniauth/provider/generic'
    autoload :Facebook,                   'omniauth/provider/facebook'
    autoload :Guests,                     'omniauth/provider/guests'
  end
end

