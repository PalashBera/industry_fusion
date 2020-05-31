class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :user_notifications do |t|
      t.references :user,     null: false, foreign_key: true
      t.string     :message,  null: false, default: ""
      t.boolean    :read,     null: false, default: false
      t.bigint     :created_by_id
      t.bigint     :updated_by_id

      t.timestamps
    end
  end
end
