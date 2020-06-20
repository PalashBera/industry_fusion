class PageHelp < ApplicationRecord
  before_validation do
    self.controller_name = controller_name.to_s.squish.downcase
    self.action_name = action_name.to_s.squish.downcase
    self.help_text = help_text.to_s.squish
    self.help_type = help_type.to_s.squish.downcase
  end

  validates :controller_name, presence: true, length: { maximum: 255 }, uniqueness: { scope: :action_name }
  validates :action_name, :help_text, :help_type, presence: true, length: { maximum: 255 }
end
