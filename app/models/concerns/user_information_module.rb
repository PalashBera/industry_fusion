module UserInformationModule
  extend ActiveSupport::Concern

  included do
    before_validation do
      self.first_name = first_name.to_s.squish.titleize
      self.last_name = last_name.to_s.squish.titleize
      self.email = email.to_s.squish.downcase
      self.mobile_number = mobile_number.to_s.squish
    end

    validates :first_name, :last_name, :email, presence: true, length: { maximum: 255 }
    validates :password, presence: true, length: { minimum: 6, maximum: 128 }, on: :create
    validates :mobile_number, presence: true, length: { is: 10 }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def initial
    "#{first_name[0]}#{last_name[0]}"
  end
end
