module AddressModule
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.address1 = address1.to_s.squish
      self.address2 = address2.to_s.squish
      self.city = city.to_s.squish.titleize
      self.state = state.to_s.squish.titleize
      self.country = country.to_s.squish.titleize
      self.pin_code = pin_code.to_s.squish
      self.phone_number = phone_number.to_s.squish
    end

    validates :address1, :city, :state, :country, presence: true, length: { maximum: 255 }
    validates :address2, :phone_number, length: { maximum: 255 }
    validates :pin_code, presence: true, length: { is: 6 }
  end

  def address
    [address1, address2, city, state, country].reject(&:blank?).join(", ")
  end
end
