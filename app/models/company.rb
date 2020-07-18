class Company < ApplicationRecord
  has_rich_text :description

  def save

    if self.zip_code.present?
      zip_code_id = ZipCodeService.new(self.zip_code).save_company_zip_data
      if zip_code_id == 0
        throw_error("Please validate your entered zip code")
        return false
      end
      self.location_id = zip_code_id
      super
    else
      throw_error("Please check your zip code")
    end
 
  end

  
  private 
  def throw_error(message)
    self.errors.add(:Error, message)
  end

end
