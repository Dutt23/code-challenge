
class LocationMetaService

  attr_reader :location_params

  def initialize(location_params)
    @location_params = location_params
  end

  def save_location
    location = Location.find_by(@location_params.except!(:time_zone))
      unless location.present?
        location = Location.new(@location_params.except!(:time_zone))
        location.save
      end
    location
  end
end