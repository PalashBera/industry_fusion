module ArchiveModule
  extend ActiveSupport::Concern

  included do
    validates :archive, inclusion: { in: [true, false] }

    scope :archived,     -> { where(archive: true) }
    scope :non_archived, -> { where(archive: false) }
  end

  def archived?
    archive?
  end

  def non_archived?
    !archived?
  end

  def archived_status
    archived? ? "Archived" : "Active"
  end
end
