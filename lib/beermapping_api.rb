class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { fetch_places_in(city) }
  end

  def self.get_bar_by_id_and_city(city, id)
    get_array = self.places_in(city)
    get_array.select{|x| x.id == id}.first
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end


  def self.key
    raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    ENV['APIKEY']
  end

  def self.gmaps_key
    raise "GMAPSAPIKEY env variable not defined" if ENV['GMAPSAPIKEY'].nil?
    ENV['GMAPSAPIKEY']
  end
end
