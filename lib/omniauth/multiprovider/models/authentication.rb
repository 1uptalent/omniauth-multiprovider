require 'hashugar'

class Authentication < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  validates :provider, :uid, presence: true

  def self.from(omniauth_data, resource)
    auth = normalize(omniauth_data)
    authentication = self.find_or_create(auth)
    authentication.access_token = auth.credentials.token
    authentication.access_token_secret = auth.credentials.secret
    authentication.resource = resource
    resource.save(validate: false)
    authentication.save
    authentication
  end

  def self.normalize(omniauth_data)
    return omniauth_data if omniauth_data.is_a? Hashugar
    normalized = omniauth_data.to_hashugar
    normalized.delete(:extra)
    normalized.credentials ||= {}
    normalized.info ||= {}
    normalized.info.delete(:description)
    normalized
  end

  private

  def self.find_or_create(auth)
    self.find_by(
      provider: auth.provider,
      uid: auth.uid) ||
    self.new(
      provider: auth.provider,
      uid: auth.uid,
      access_token: auth.credentials.token)
  end

end
