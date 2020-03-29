module Archivable
  extend ActiveSupport::Concern

  included do
    validates :archive, inclusion: { in: [true, false] }

    scope :archived,     -> { where(archive: true) }
    scope :non_archived, -> { where(archive: false) }
  end
end
