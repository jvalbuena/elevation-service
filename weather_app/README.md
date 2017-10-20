# for WeatherApp to work you'll need to start the little elevation which I 'borrowed' from github

I've copied instructions from it's README.md

In a nutshell:

```
npm install
```

and fire it up:

```
node index.js
```

It runs on port 5001 for now.

Post a GeoJSON object to its only endpoint, `/geojson`, and you will get the same object back, but its
coordinates will have a third component containing elevation added.


Once the elevation service is online:

```
ruby weather.rb
````

Note that: Data will be persisted in /tmp/weather.data and wiped out in every execution, first run maybe slow if elevation data is not present, I have pre-selected 10 locations are pre-loaded elevation data.