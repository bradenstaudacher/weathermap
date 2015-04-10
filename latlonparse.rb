require "net/http"
require "uri"
require "json"
require 'pry'
require 'csv'

weather_url = 'http://api.wunderground.com/api/44f0caac7402487f/conditions/q/'
weather_url_test = 'http://api.wunderground.com/api/44f0caac7402487f/conditions/q/34.516666666666666,69.183333.json'
uri = URI.parse("http://techslides.com/demos/country-capitals.json")

response = Net::HTTP.get_response(uri)

data = JSON.parse(response.body)
array_of_latlongs = []
array_of_capitals_information = []

data.each do |country|
  if country['CapitalLatitude'] != '0' && country['CapitalLatitude'] != ' D.C.'
    array_of_latlongs << [country['CapitalLatitude'] + ',' + country['CapitalLongitude'] + '.json']
  end
end

array_of_latlongs_test = array_of_latlongs[241..250]

binding.pry

array_of_latlongs_test.each do |latlong|
  ########## SETUP THE URI BASED ON URL FROM CAPITAL FROM LIST ###########
  uri2 = URI.parse(weather_url + latlong[0])
  response2 = Net::HTTP.get_response(uri2)
  data2 = JSON.parse(response2.body)
  ########### GET RESPONSE FROM SERVER AND OPEN IT UP ################
  observations = data2['current_observation']
  ############# DATA GRAB ###################
  city = observations['display_location']['city']
  country = observations['display_location']['state_name']
  latitude = observations['display_location']['latitude']
  longitude = observations['display_location']['longitude']
  elevation = observations['display_location']['elevation']
  temp_c = observations['temp_c']
  wind_degrees = observations['wind_degrees']
  wind_kph = observations['wind_kph']
  pressure_mb = observations['pressure_mb']
  dewpoint_c = observations['dewpoint_c']
  uv = observations['UV']
  precip_today_metric = observations['precip_today_metric']
  relative_humidity = observations['relative_humidity'].to_i
  ############## GENERATE FULL LIST OF INFO FOR EACH latlong ###################
  allinfo = [city, country, latitude, longitude, elevation, temp_c, wind_degrees, wind_kph, pressure_mb, dewpoint_c, uv, precip_today_metric, relative_humidity]
  array_of_capitals_information << allinfo
end


CSV.open("capitalweather.csv", "a") do |csv|
  array_of_capitals_information.each do |row|
    csv << row
  end
end



