class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :async, :confirmable

  before_validation { self.first_name = first_name.to_s.squish.titleize }
  before_validation { self.last_name = last_name.to_s.squish.titleize }
  before_validation { self.email = email.to_s.squish.downcase }
  before_validation { self.mobile_number = mobile_number.to_s.squish }

  validates :first_name, :last_name, presence: true, length: { maximum: 255 }
  validates :mobile_number, presence: true, length: { is: 10 }

  def full_name
    "#{first_name} #{last_name}"
  end

  def initial
    "#{first_name[0]}#{last_name[0]}"
  end

  # def send_on_create_confirmation_instructions
  #   Devise::Mailer.send_confirmation_instructions.perform_later
  # end

  # def send_reset_password_instructions
  #   Devise::Mailer.delay.reset_password_instructions(self)
  # end

  # def send_confirmation_instructions
  #   Devise::Mailer.delay.confirmation_instructions(self)
  # end
end
