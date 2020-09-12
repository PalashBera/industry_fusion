require "csv"
require "string"
require "array"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.import(file)
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      create(row.to_h)
    end
  end
end
