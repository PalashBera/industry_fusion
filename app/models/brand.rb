class Brand < ApplicationRecord
  include Archivable
  include ModalFormable
  include UserTrackable

  acts_as_tenant(:organization)
  has_paper_trail ignore: %i[created_at updated_at]

  before_validation { self.name = name.to_s.squish }

  belongs_to :organization

  validates :name, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false, scope: :organization_id }

  scope :order_by_name, -> { order(:name) }

  def self.import(file)
    spreadsheet = open_spreadsheet(file)

    (2..spreadsheet.last_row).each do |i|
      brand = new
      brand.name = spreadsheet.row(i)[0]
      brand.save
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise StandardError, "Unknown file type: #{file.original_filename}"
    end
  end
end
