class User < ActiveRecord::Base
  devise :database_authenticatable
  omniauthenticable
end
