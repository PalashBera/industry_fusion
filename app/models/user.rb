class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :async, :confirmable, :trackable

  before_validation { self.first_name = first_name.to_s.squish.titleize }
  before_validation { self.last_name = last_name.to_s.squish.titleize }
  before_validation { self.email = email.to_s.squish.downcase }
  before_validation { self.mobile_number = mobile_number.to_s.squish }

  validates :first_name, :last_name, :email, presence: true, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 6, maximum: 128 }, on: :create
  validates :mobile_number, presence: true, length: { is: 10 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def initial
    "#{first_name[0]}#{last_name[0]}"
  end
end
