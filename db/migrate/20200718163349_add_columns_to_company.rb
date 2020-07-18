class AddColumnsToCompany < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :location_id, :bigint
    add_column :companies, :status, :integer, default: STATUS[:active]
    add_column :companies, :source, :integer, default: SOURCE[:default]
  end
end
