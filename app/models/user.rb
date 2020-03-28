class User < ApplicationRecord
  before_validation { self.first_name = first_name.squish.titleize }
  before_validation { self.last_name = last_name.squish.titleize }
  before_validation { self.email = email.squish.downcase }
  before_validation { self.mobile_number = mobile_number.squish }

  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  validates :mobile_number, presence: true, length: { is: 10 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def initial
    "#{first_name[0]}#{last_name[0]}"
  end
end
