require "csv"
require "addressable"
require "archivable"
require "modal_formable"
require "nameable"
require "user_trackable"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.import(file)
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      create(row.to_h)
    end
  end
end
