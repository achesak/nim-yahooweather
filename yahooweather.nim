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
type YWeather* = tuple[sunrise : string, sunset : string, humidity : string, pressure : string, rising : string, 
                       visibility : string, code : string, date : string, temp : string, condition : string, title : string,
                       latitude : string, longitude : string, htmlDescription : string, link : string, city : string,
                       country : string, region : string, windChill : string, windDirection : string, windSpeed : string,
                       distanceUnits : string, pressureUnits : string, speedUnits : string, tempUnits : string]

type YWeatherForecast* = tuple[code : string, date : string, day : string, high : string, low : string, text : string]


proc getWeather*(woeid : string, units : string = "c"): YWeather = 
    ## Gets the weather data.
    
    # Build the URL.
    var url : string = "http://weather.yahooapis.com/forecastrss?"
    url = url & "w=" & woeid & "&u=" & units
    
    # Get the data
    var response : string = newHttpClient().getContent(url)
    
    # Parse the XML.
    var xml : XmlNode = parseXML(newStringStream(response))
    var contents : XmlNode = xml.child("channel")
    var item : XmlNode = contents.child("item")
    
    # Create the return object.
    var weather : YWeather
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


proc getForecasts*(woeid : string, units : string = "c"): array[5, YWeatherForecast] = 
    ## Gets forecasts for the next five days.
    
    # Build the URL.
    var url : string = "http://weather.yahooapis.com/forecastrss?"
    url = url & "w=" & woeid & "&u=" & units
    
    # Get the data
    var response : string = newHttpClient().getContent(url)
    
    # Parse the XML.
    var xml : XmlNode = parseXML(newStringStream(response))
    var item : XmlNode = xml.child("channel").child("item")
    
    # Create the return objects.
    var weather0 : YWeatherForecast
    var weather1 : YWeatherForecast
    var weather2 : YWeatherForecast
    var weather3 : YWeatherForecast
    var weather4 : YWeatherForecast
    
    # Set the days.
    weather0.day = item.findAll("yweather:forecast")[0].attr("day")
    weather1.day = item.findAll("yweather:forecast")[1].attr("day")
    weather2.day = item.findAll("yweather:forecast")[2].attr("day")
    weather3.day = item.findAll("yweather:forecast")[3].attr("day")
    weather4.day = item.findAll("yweather:forecast")[4].attr("day")
    
    # Set the dates.
    weather0.date = item.findAll("yweather:forecast")[0].attr("date")
    weather1.date = item.findAll("yweather:forecast")[1].attr("date")
    weather2.date = item.findAll("yweather:forecast")[2].attr("date")
    weather3.date = item.findAll("yweather:forecast")[3].attr("date")
    weather4.date = item.findAll("yweather:forecast")[4].attr("date")
    
    # Set the lows.
    weather0.low = item.findAll("yweather:forecast")[0].attr("low")
    weather1.low = item.findAll("yweather:forecast")[1].attr("low")
    weather2.low = item.findAll("yweather:forecast")[2].attr("low")
    weather3.low = item.findAll("yweather:forecast")[3].attr("low")
    weather4.low = item.findAll("yweather:forecast")[4].attr("low")
    
    # Set the highs.
    weather0.high = item.findAll("yweather:forecast")[0].attr("high")
    weather1.high = item.findAll("yweather:forecast")[1].attr("high")
    weather2.high = item.findAll("yweather:forecast")[2].attr("high")
    weather3.high = item.findAll("yweather:forecast")[3].attr("high")
    weather4.high = item.findAll("yweather:forecast")[4].attr("high")
    
    # Set the texts.
    weather0.text = item.findAll("yweather:forecast")[0].attr("text")
    weather1.text = item.findAll("yweather:forecast")[1].attr("text")
    weather2.text = item.findAll("yweather:forecast")[2].attr("text")
    weather3.text = item.findAll("yweather:forecast")[3].attr("text")
    weather4.text = item.findAll("yweather:forecast")[4].attr("text")
    
    # Set the codes.
    weather0.code = item.findAll("yweather:forecast")[0].attr("code")
    weather1.code = item.findAll("yweather:forecast")[1].attr("code")
    weather2.code = item.findAll("yweather:forecast")[2].attr("code")
    weather3.code = item.findAll("yweather:forecast")[3].attr("code")
    weather4.code = item.findAll("yweather:forecast")[4].attr("code")
    
    # Return the array.
    return [weather0, weather1, weather2, weather3, weather4]
