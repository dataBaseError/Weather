class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :search_param, null: false

      t.string :city
      t.string :state
      t.string :country, null: false

      t.string :weather_type, null: false
      t.decimal :tempature, null: false

      t.boolean :random, default: false, null: false

      t.timestamps null: false
    end
    add_reference :histories, :user, foreign_key: true
  end
end
