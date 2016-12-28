//
//  WeatherClient.swift
//  myWeatherForecast
//
//  Created by Warren Hansen on 12/20/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import Foundation
import UIKit

struct ForecastDetail {
    let high: String
    let low: String
    let conditions: String
    let icon: String
    let pop: Float
    let humidity: Float
}

struct ForecastDate {
    let yday: Int
    let weekdayShort: String
    let weekday: String
}

func setIcon(input:String)-> UIImage {
    
    var thisImage:UIImage
    
    switch input {
    case "chancerain":
        thisImage = UIImage(named: "chancerain")!
    case "chancetstorms":
        thisImage =  UIImage(named: "chancetstorms")!
    case "clear":
        thisImage = UIImage(named: "clear")!
    case "nt_clear":
        thisImage = UIImage(named: "nt_clear")!
    case "partlycloudy":
        thisImage = UIImage(named: "partlycloudy")!
    case "overcast":
        thisImage = UIImage(named: "overcast")!
    case "cloudy":
        thisImage = UIImage(named: "overcast")!
    case "mostlycloudy":
        thisImage = UIImage(named: "overcast")!
    case "rain":
        thisImage = UIImage(named: "chancerain")!
    case "nt_partlycloudy":
        thisImage = UIImage(named: "partlycloudy")!
    case "snow":
        thisImage = UIImage(named: "snow")!
    case "fog":
        thisImage = UIImage(named: "snow")!
    default:
        thisImage = UIImage(named: "none")!
    }
    
    return thisImage
}

extension ForecastDate {
    
    /// Initialize ForecastDate model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionary from json data
        guard let date = json["date"] as? [String: Any] else { return nil }
        
        // extract values from dictionary
        guard let yd = date["yday"] as? Int else { return nil }
        guard let dayshort = date["weekday_short"] as? String else { return nil }
        guard let day = date["weekday"] as? String else { return nil }
        
        // set struct properties
        self.yday = yd
        self.weekdayShort = dayshort
        self.weekday = day
    }
    
    /// An array of ForecastDate structs from JSON data.
    /// - parameter json: JSON data
    
    static func forecastDateArray(json: [String: Any]) -> [ForecastDate]? {
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastArray = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        let forecasts = forecastArray.flatMap{ ForecastDate(json: $0) }
        return forecasts.count > 0 ? forecasts : nil    // if array has no elements return nil
    }
}

extension ForecastDetail {
    
    /// Initialize ForecastDetail model from JSON data.
    /// - parameter json: JSON data
    
    init?(json: [String: Any]) {
        
        // extract dictionaries from json data
        guard let high = json["high"] as? [String: Any] else { return nil }
        guard let low = json["low"] as? [String: Any] else { return nil }
        
        // extract values from dictionaries
        guard let hi = high["fahrenheit"] as? String else { return nil }
        guard let lo = low["fahrenheit"] as? String else { return nil }
        guard let co = json["conditions"] as? String else { return nil }
        guard let ic = json["icon"] as? String else { return nil }
        guard let po = json["pop"] as? Float else { return nil }
        guard let hu = json["avehumidity"] as? Float else { return nil }
        
        // set struct properties
        self.high = hi
        self.low = lo
        self.conditions = co
        self.icon = ic
        self.pop = po
        self.humidity = hu
    }
    
    /// An array of ForecastDetail structs from JSON data.
    /// - parameter json: JSON data
    
    static func forecastDetialArray(json: [String: Any]) -> [ForecastDetail]? {
        guard let forecast = json["forecast"] as? [String: Any] else { return nil }
        guard let simpleforecast = forecast["simpleforecast"] as? [String: Any] else { return nil }
        guard let forecastArray = simpleforecast["forecastday"] as? [[String: Any]] else { return nil }
        let forecasts = forecastArray.flatMap{ ForecastDetail(json: $0) }
        return forecasts.count > 0 ? forecasts : nil    // if array has no elements return nil
    }
}

