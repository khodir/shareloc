class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations, id: false do |t|
      t.uuid        :location_id, primary_key: true, default: "uuid_generate_v4()"
      t.integer     :user_id, null: false
      t.string      :location_name, null: false
      t.string      :tag, null: false
      t.decimal     :longtitude, precision: 64, scale: 9, null: false
      t.decimal     :latitude, precision: 64, scale: 9, null: false
      t.string      :created_by
      t.string      :updated_by
      t.timestamps
    end

    add_foreign_key :locations, :users,
    column: :user_id, primary_key: :id,
    on_update: :cascade, on_delete: :cascade
  end
end
