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


# Create the return type.
type TYWeather* = tuple[sunrise : string, sunset : string, humidity : string, pressure : string, rising : string, 
                       visibility : string, code : string, date : string, temp : string, text : string, title : string, latitude : string, logitude : string, htmlDescription : string, link : string, city : string, country : string, region : string, windChill : string, windDirection : string, windSpeed : string, distanceUnits : string, pressureUnits : string, speedUnits : string, tempUnits : string]

