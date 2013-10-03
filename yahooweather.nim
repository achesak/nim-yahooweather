# Yahoo! Weather API wrapper.


# Written by Adam Chesak.
# Code released under the MIT open source license.


# Import modules.
import httpclient
import cgi
import strutils
import xmlparser
import xmltree
import streams


# Create the return types.
type TYWeather* = tuple[sunrise : string, sunset : string, humidity : string, pressure : string, rising : string, 
                       visibility : string, code : string, date : string, temp : string, condition : string, title : string,
                       latitude : string, longitude : string, htmlDescription : string, link : string, city : string,
                       country : string, region : string, windChill : string, windDirection : string, windSpeed : string,
                       distanceUnits : string, pressureUnits : string, speedUnits : string, tempUnits : string]

type TYWeatherForcast* = tuple[code : string, date : string, day : string, high : string, low : string, text : string]


proc getWeather*(woeid : string, units : string = "c"): TYWeather = 
    # Gets the weather data.
    
    # Build the URL.
    var url : string = "http://weather.yahooapis.com/forecastrss?"
    url = url & "w=" & woeid & "&u=" & units
    
    # Get the data
    var response : string = getContent(url)
    
    # Parse the XML.
    var xml : PXmlNode = parseXML(newStringStream(response))
    var contents : PXmlNode = xml.child("channel")
    var item : PXmlNode = contents.child("item")
    
    # Create the return object.
    var weather : TYWeather
    weather.link = contents.child("link").innerText
    weather.date = contents.child("lastBuildDate").innerText
    weather.city = contents.child("yweather:location").attr("city")
    weather.country = contents.child("yweather:location").attr("country")
    weather.region = contents.child("yweather:location").attr("region")
    weather.distanceUnits = contents.child("yweather:units").attr("distance")
    weather.pressureUnits = contents.child("yweather:units").attr("pressure")
    weather.speedUnits = contents.child("yweather:units").attr("speed")
    weather.tempUnits = contents.child("yweather:units").attr("temperature")
    weather.windChill = contents.child("yweather:wind").attr("chill")
    weather.windDirection = contents.child("yweather:wind").attr("direction")
    weather.windSpeed = contents.child("yweather:wind").attr("speed")
    weather.humidity = contents.child("yweather:atmosphere").attr("humidity")
    weather.visibility = contents.child("yweather:atmosphere").attr("visibility")
    weather.pressure = contents.child("yweather:atmosphere").attr("pressure")
    weather.rising = contents.child("yweather:atmosphere").attr("rising")
    weather.sunrise = contents.child("yweather:astronomy").attr("sunrise")
    weather.sunset = contents.child("yweather:astronomy").attr("sunset")
    weather.title = item.child("title").innerText
    weather.latitude = item.child("geo:lat").innerText
    weather.longitude = item.child("geo:long").innerText
    weather.condition = item.child("yweather:condition").attr("text")
    weather.code = item.child("yweather:condition").attr("code")
    weather.temp = item.child("yweather:condition").attr("temp")
    weather.htmlDescription = item.child("description").innerText
    
    # Return the weather data.
    return weather


proc getForecasts*(woeid : string, units : string = "c"): array[5, TYWeatherForcast] = 
    # Gets forcasts for the next five days.
    
    ## WRITE THIS!!!