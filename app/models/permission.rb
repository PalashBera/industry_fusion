class Permission < ApplicationRecord
  has_and_belongs_to_many :roles

  validates :name, :subject_class, :action, :group, presence: true, length: { maximum: 255 }
  validates :subject_class, uniqueness: { scope: :action }

  scope :for_master, -> { where(group: "master") }
end
