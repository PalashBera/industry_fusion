class CreateQuotationRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :quotation_requests do |t|
      t.references :company,       null: false, foreign_key: true
      t.references :warehouse,     null: false, foreign_key: true
      t.integer    :serial,        null: false
      t.string     :serial_number, null: false
      t.string     :status,        null: false, default: "created"
      t.text       :note,          default: ""
      t.references :organization,  null: false, foreign_key: true
      t.bigint     :created_by_id, index: true
      t.bigint     :updated_by_id, index: true

      t.timestamps
    end

    create_table :quotation_request_items do |t|
      t.references :quotation_request, null: false, foreign_key: true
      t.references :indent_item,       null: false, foreign_key: true
      t.bigint     :created_by_id,                  index: true
      t.bigint     :updated_by_id,                  index: true

      t.timestamps
    end

    create_table :quotation_request_vendors do |t|
      t.references :quotation_request, foreign_key: true, null: false
      t.references :vendorship,        foreign_key: true, null: false
      t.bigint     :created_by_id,                        index: true
      t.bigint     :updated_by_id,                        index: true

      t.timestamps
    end
  end
end
