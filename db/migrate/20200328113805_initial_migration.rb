class InitialMigration < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## User information
      t.string  :first_name,         null: false, default: ""
      t.string  :last_name,          null: false, default: ""
      t.string  :mobile_number,      null: false, default: ""
      t.boolean :admin,              null: false, default: false

      ## Organization references
      t.references :organization, foreign_key: true

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Invitable
      t.string     :invitation_token
      t.datetime   :invitation_created_at
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, polymorphic: true
      t.integer    :invitations_count, index: true

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :invitation_token,     unique: true
    # add_index :users, :unlock_token,         unique: true

    create_table :vendors do |t|
      ## User Information
      t.string :first_name,        null: false, default: ""
      t.string :last_name,         null: false, default: ""
      t.string :mobile_number,     null: false, default: ""

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Invitable
      t.string     :invitation_token
      t.datetime   :invitation_created_at
      t.datetime   :invitation_sent_at
      t.datetime   :invitation_accepted_at
      t.integer    :invitation_limit
      t.references :invited_by, polymorphic: true
      t.integer    :invitations_count, index: true

      t.timestamps
    end

    add_index :vendors, :email,                unique: true
    add_index :vendors, :reset_password_token, unique: true
    add_index :vendors, :confirmation_token,   unique: true
    add_index :vendors, :invitation_token,     unique: true
    # add_index :users, :unlock_token,         unique: true
  end

  create_table :store_informations do |t|
    t.bigint   :vendor_id,     index: true,    null: false, foreign_key: true
    t.string   :name,                          null: false
    t.string   :address1,                      null: false
    t.string   :address2,      default: ""
    t.string   :city,                          null: false
    t.string   :state,                         null: false
    t.string   :country,                       null: false
    t.string   :pin_code,      limit: 6,       null: false
    t.string   :phone_number,  default: ""
    t.string   :pan_number,    limit: 10,      null: false
    t.string   :gstn,          limit: 15,      null: false

    t.timestamps
  end

  create_table :organizations do |t|
    t.string   :name,                          null: false
    t.string   :address1,                      null: false
    t.string   :address2,      default: ""
    t.string   :city,                          null: false
    t.string   :state,                         null: false
    t.string   :country,                       null: false
    t.string   :pin_code,      limit: 6,       null: false
    t.string   :phone_number,  default: ""
    t.boolean  :archive,       default: false, null: false
    t.bigint   :created_by_id, index: true
    t.bigint   :updated_by_id, index: true

    t.timestamps
  end

  create_table :brands do |t|
    t.string     :name,                             null: false
    t.boolean    :archive,       default: false,    null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true, null: false

    t.timestamps
  end

  create_table :companies do |t|
    t.string     :name,                             null: false
    t.string     :short_name,    limit: 3,          null: false
    t.string     :address1,                         null: false
    t.string     :address2,      default: ""
    t.string     :city,                             null: false
    t.string     :state,                            null: false
    t.string     :country,                          null: false
    t.string     :pin_code,      limit: 6,          null: false
    t.string     :phone_number,  default: ""
    t.boolean    :archive,       default: false,    null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true, null: false

    t.timestamps
  end

  create_table :warehouses do |t|
    t.references :company,       foreign_key: true, null: false
    t.string     :name,                             null: false
    t.string     :short_name,    limit: 3,          null: false
    t.string     :address1,                         null: false
    t.string     :address2,      default: ""
    t.string     :city,                             null: false
    t.string     :state,                            null: false
    t.string     :country,                          null: false
    t.string     :pin_code,      limit: 6,          null: false
    t.string     :phone_number,  default: ""
    t.boolean    :archive,       default: false,    null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true, null: false

    t.timestamps
  end

  create_table :uoms do |t|
    t.string     :name,                             null: false
    t.string     :short_name,    limit: 4,          null: false
    t.boolean    :archive,       default: false,    null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true, null: false

    t.timestamps
  end

  create_table :item_groups do |t|
    t.string     :name,                             null: false
    t.text       :description,   default: ""
    t.boolean    :archive,       default: false,    null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true, null: false

    t.timestamps
  end

  create_table :cost_centers do |t|
    t.string     :name,                             null: false
    t.text       :description,   default: ""
    t.boolean    :archive,       default: false,    null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true, null: false

    t.timestamps
  end

  create_table :items do |t|
    t.references :item_group,    foreign_key: true,            null: false
    t.references :uom,           foreign_key: true,            null: false
    t.references :secondary_uom, foreign_key: { to_table: :uoms }
    t.string     :name,                                        null: false
    t.decimal    :primary_quantity,   precision: 10, scale: 2
    t.decimal    :secondary_quantity, precision: 10, scale: 2
    t.boolean    :archive,       default: false,               null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true,            null: false

    t.timestamps
  end

  create_table :makes do |t|
    t.references :brand,         foreign_key: true, null: false
    t.references :item,          foreign_key: true, null: false
    t.string     :cat_no,        default: ""
    t.boolean    :archive,       default: false,    null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true, null: false

    t.timestamps
  end

  create_table :indents do |t|
    t.references :company,      foreign_key: true, null: false
    t.references :warehouse,    foreign_key: true, null: false
    t.bigint     :serial,                          null: false
    t.date       :requirement_date,                null: false
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization, foreign_key: true, null: false

    t.timestamps
  end

  create_table :indent_items do |t|
    t.references :indent,        foreign_key: true,  null: false
    t.references :item,          foreign_key: true,  null: false
    t.references :uom,           foreign_key: true,  null: false
    t.references :cost_center,   foreign_key: true,  null: false
    t.decimal    :quantity,                          null: false, precision: 12, scale: 2
    t.string     :priority,      default: "default", null: false
    t.references :make,          foreign_key: true
    t.string     :note,          default: ""
    t.bigint     :created_by_id, index: true
    t.bigint     :updated_by_id, index: true
    t.references :organization,  foreign_key: true,  null: false

    t.timestamps
  end
end
