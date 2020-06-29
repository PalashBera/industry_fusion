module ShortNameModule
  extend ActiveSupport::Concern

  included do
    before_validation { self.short_name = short_name.to_s.squish.upcase }

    validates :short_name, presence: true, length: { maximum: 3 }, uniqueness: { case_sensitive: false, scope: :organization_id }
  end
end
