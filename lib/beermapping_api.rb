class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    # cached data expires in 1 week
    Rails.cache.fetch(city, :expires_in => 604_800.seconds) { get_places_in(city) }
  end

  def self.get_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.place_with_id(place_id)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{place_id}"

    response = HTTParty.get url.to_s
    place = response.parsed_response["bmp_locations"]["location"]

    Place.new(place)
  end

  # export BEERMAPPING_APIKEY="aea5b3ad2f778ef73d54e2e621bc785a" in ~/.bashrc
  # delete this later ^
  def self.key
    raise "BEERMAPPING_APIKEY env variable not defined" if ENV['BEERMAPPING_APIKEY'].nil?

    ENV['BEERMAPPING_APIKEY']
  end
end
