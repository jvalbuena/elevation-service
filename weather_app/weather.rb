#This part should help quering elevation data for each location
# We have a dependancy on elevation service being avaiable  https://github.com/perliedman/elevation-service/

require 'uri'
require 'net/http'
require 'json'
require 'ostruct'

url = URI("http://localhost:5001/geojson")
%x(cp weather_template.data /tmp/weather.data >&2)

http = Net::HTTP.new(url.host, url.port)

# Nasty but should do for now
 payload =['{
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [
        -74.10827636718751,
        4.477856485570586
      ]
    },
    "properties": {}
  }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       11.9, 59
     ]
   },
   "properties": {}
 }','{
    "type": "Feature",
    "geometry": {
      "type": "Point",
      "coordinates": [
        -50.97656250000001,
        -8.407168163601076
      ]
    },
    "properties": {}
  }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       -59.98535156250001,
       -3.2502085616531686
     ]
   },
   "properties": {}
 }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       -68.02734375000001,
       -16.55196172197251
     ]
   },
   "properties": {}
 }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       -70.48828125000001,
       -33.46810795527895
     ]
   },
   "properties": {}
 }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       -47.81250000000001,
       -15.834535741221552
     ]
   },
   "properties": {}
 }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       150.11718750000003,
       -33.96158628979909
     ]
   },
   "properties": {}
 }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       145.01953125000003,
       -37.75334401310657
     ]
   },
   "properties": {}
 }','{
   "type": "Feature",
   "geometry": {
     "type": "Point",
     "coordinates": [
       137.72460937500003,
       -32.39851580247402
     ]
   },
   "properties": {}
 }']

# We are going to strip Geometry data out of each payload
payload.each do |payload|   
  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'application/json'
  request["cache-control"] = 'no-cache'
  request.body = payload

  # This should bring geometry data out of the array
  response = http.request(request)
  body = response.read_body
  parsed = JSON.parse(body)
  #puts parsed
  t = parsed['geometry']
  #puts t
  #a = t.collect{|a| a[1]}
  #coordinates=a.delete("Point") #Get rid of Point element
  #puts a.to_s
  object = JSON.parse(body, object_class: OpenStruct)
  
  $latitude = object.geometry{1}.coordinates[1]
  $longitude = object.geometry{1}.coordinates[0]
  $altitude = object.geometry{1}.coordinates[2]
  ############ 
  # We need time and figure out a correction factor for TOD.
    t = Time.now
    if t.hour < 13
      correction_factor = t.hour* 0.2
    else
      correction_factor = - t.hour.to_f * 0.2
    end

  # Initialise temp and calculate according to altitude and TOD.
      base_temp = 25
      forecast_temp = base_temp+2*$altitude.to_i/1200 + correction_factor

  # Feed data into an array   
  row = Array.new
  row << t
  row << $latitude 
  row << $longitude
  row << $altitude
  row << forecast_temp
  puts row.to_a.join("|")

  File.open("/tmp/weather.data","a") do |f|
      f.write row.to_a.join("|")
      f.write "\n"
  end 
end



  
  
  