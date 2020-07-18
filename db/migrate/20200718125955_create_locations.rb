class CreateLocations < ActiveRecord::Migration[6.0]
  def up
    create_table :locations do |t|
      t.string :city, null: false
      t.string :state_name
      t.string :state_code, null: false
      t.integer :status, null: false, default: -> { 1 } #1 comes default active status
      t.integer :source, null: false, default: -> { 1 } #Default source 1
      t.integer :created_by, null: false, default: -> { 99 }
      t.integer :updated_by, null: true, default: -> { 99 }  #System id 99.
      t.datetime :created_at, null: false, default: -> { 'NOW()' }
      t.datetime :updated_at, null: true, default: -> { 'NOW()' }, on_update: -> { 'NOW()' }
    end
    add_index :locations ,[:city , :state_code], name: 'locations_city_state_code_idx'
  end

  def down
    remove_index :locations, [ :city, :state_code]
    drop_table :locations
  end
end
