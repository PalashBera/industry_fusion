require "csv"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      create(row.to_h)
    end
  end
end
