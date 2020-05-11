class Vendor < ApplicationRecord
  include ModalFormable
  include UserInformable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :confirmable, :trackable, :async

  has_one :store_information
end
