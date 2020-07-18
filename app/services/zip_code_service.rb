
class ZipCodeService

  attr_reader :code

  def initialize(code)
    @code = code
  end

  def save_company_zip_data
    zip_code = get_zip_code_data(@code)
    return zip_code;
  end

  private

  def get_zip_code_data(code)
    zip_code = fetch_zip_code_from_db(code)
    if zip_code.present?
      return zip_code.id
    else
      zip_code_data = ZipCodes.identify(code)
      return 0 if !zip_code_data.present?
      location_meta_id = seed_location_data(zip_code_data)
      return save_zip_code_data(code, location_meta_id).id
    end
    
  end

  def save_zip_code_data(code, location_meta_id)
    zip = ZipCodeData.new(
      code: code,
      location_id: location_meta_id
    )
    zip.save
    zip
  end

  def fetch_zip_code_from_db(code)
    ZipCodeData.find_by_code(code)
  end

  def seed_location_data(location_data)
    return LocationMetaService.new(location_data).save_location.id
  end
end