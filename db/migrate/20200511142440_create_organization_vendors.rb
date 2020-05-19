class CreateOrganizationVendors < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_vendors do |t|
      t.references :organization,  foreign_key: true, null: false
      t.references :vendor,        foreign_key: true, null: false
      t.boolean    :archive,       default: false,    null: false
      t.bigint     :created_by_id, index: true
      t.bigint     :updated_by_id, index: true

      t.timestamps
    end

    add_index :organization_vendors, [ :organization_id, :vendor_id ], unique: true
  end
end
