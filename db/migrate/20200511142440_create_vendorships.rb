class CreateVendorships < ActiveRecord::Migration[6.0]
  def change
    create_table :vendorships do |t|
      t.references :organization,       foreign_key: true, null: false
      t.references :vendor,             foreign_key: true, null: false
      t.boolean    :archive,            default: false,    null: false
      t.datetime   :invitation_sent_at
      t.bigint     :created_by_id,      index: true
      t.bigint     :updated_by_id,      index: true

      t.timestamps
    end

    add_index :vendorships, [ :organization_id, :vendor_id ], unique: true
  end
end
