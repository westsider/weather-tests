//
//  Weather.swift
//  myWeatherForecast
//
//  Created by Warren Hansen on 12/29/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import Foundation

class CurrentWeather {
    
    // share single object across classes
    static let sharedInstance = CurrentWeather()
    
    //  current waether
    var currentCity = ""
    
    var currentTemp = ""
    
    var currentConditions = ""
    
    //  forecast day one
    var forecastOneDay = ""
    
    var forecastOneIcon = ""
    
    var forecastOneHiLo = ""
    
    var forecastOneConditions = ""
    
    //  forecast day two
    var forecastTwoDay = ""
    
    var forecastTwoIcon = ""
    
    var forecastTwoHiLo = ""
    
    var forecastTwoCond = ""
    
    //  forecast day three
    var forecastThreeDay = ""
    
    var forecastThreeIcon = ""
    
    var forecastThreeHiLo = ""
    
    var forecastThreeCond = ""
    
    var url = NSURL(string: "https://api.wunderground.com/api")
    
    var forcastURL = NSURL(string: "api.openweathermap.org/data/2.5/forecast/q={city name},{country code}&cnt={cnt}")
    
    func updateUrl(last: String, first: String) {
        url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + last + "/" + first + ".json")
        forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/" + last + "/" + first + ".json")
        
        //url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + last + "/" + first.replacingOccurrences(of: " ", with: "_") + ".json")
        //forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/" + last + "/" + first.replacingOccurrences(of: " ", with: "_") + ".json")
    }
}

class CurrentLocation {
    
    static let sharedInstance = CurrentLocation()
    
    var cityInput = ""
    
    var last = ""
    
    var first = ""
    
    
}
