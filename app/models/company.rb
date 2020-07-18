class Company < ApplicationRecord
  has_rich_text :description

  validates_format_of :email, :allow_blank => true,:with => /\b[A-Z0-9._%a-z\-]+@getmainstreet\.com\z/, :message => "is invalid, please validate the domain and format"

  validates_format_of :phone, length: {minimum: 10, maximum: 10}, :allow_blank => true,:with => /(?:\+?|\b)[0-9]{10}\b/, :message => "is invalid, please validate the entered number"

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
