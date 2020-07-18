class CreateZipcode < ActiveRecord::Migration[6.0]
  def up
    create_table :zip_codes do |t|
      t.string :code, null: false
      t.bigint :location_id
      t.integer :status, null: false, default: -> { 1 } #1 comes default active status
      t.integer :source, null: false, default: -> { 1 } #Default source 1
      t.integer :created_by, null: false, default: -> { 99 }
      t.integer :updated_by, null: true, default: -> { 99 }  #System id 99.
      t.datetime :created_at, null: false, default: -> { 'NOW()' }
      t.datetime :updated_at, null: true, default: -> { 'NOW()' }, on_update: -> { 'NOW()' }
    end
    add_index :zip_codes ,:code, unique: true
  end

  def down
    remove_index :zip_codes ,:code
    drop_table :zip_codes
  end
end
