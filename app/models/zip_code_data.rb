class ZipCodeData < ApplicationRecord
  self.table_name = "zip_codes"
  validates :code, presence: true
end
  