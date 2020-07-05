require "jwt"

class Auth
  ALGORITHM = "HS256".freeze
  SECRET_KEY_BASE = Rails.application.credentials.secret_key_base

  def self.issue(payload)
    JWT.encode(payload.merge(exp: 1.week.from_now.to_i), SECRET_KEY_BASE, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, SECRET_KEY_BASE)
  rescue JWT::DecodeError => e
    { errors: e.message }
  end
end
