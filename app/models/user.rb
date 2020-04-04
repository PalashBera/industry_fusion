class User < ApplicationRecord
  cattr_accessor :current_user

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :async, :confirmable, :trackable

  before_validation { self.first_name = first_name.to_s.squish.titleize }
  before_validation { self.last_name = last_name.to_s.squish.titleize }
  before_validation { self.email = email.to_s.squish.downcase }
  before_validation { self.mobile_number = mobile_number.to_s.squish }

  belongs_to :organization, optional: true

  validates :first_name, :last_name, :email, presence: true, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 6, maximum: 128 }, on: :create
  validates :mobile_number, presence: true, length: { is: 10 }
  validates :admin, inclusion: { in: [true, false] }

  def full_name
    "#{first_name} #{last_name}"
  end

  def initial
    "#{first_name[0]}#{last_name[0]}"
  end

  def admin?
    admin
  end

  def non_admin?
    !admin?
  end

  def add_organization(organization)
    update(admin: true, organization_id: organization.id)
  end
end
