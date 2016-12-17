//
//  ViewController.swift
//  myWeatherForecast
//
//  Created by Warren Hansen on 12/17/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var cityInput: UISearchBar!
    
    @IBOutlet weak var weatherOutput: UILabel!
    
    @IBOutlet weak var weatherReport: UITextView!
    
    var url = NSURL(string: "https://api.wunderground.com/api")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityInput.text = "Venice CA"
    }


    @IBAction func searchAction(_ sender: Any) {
        findOnMap(input: cityInput.text!)
        findWeather()
    }

    // MARK: - Parse Location
    func findOnMap(input: String) {
        let location = cityInput.text!
        let str = location
        let split = str.characters.split(separator: " ")
        let size = split.count
        var last = ""
        var first = ""
        
        switch size {
            
        case 2:
            last    = String(split.suffix(1).joined(separator: [" "]))
            first = String(split.prefix(upTo: 1).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + last + "/" + first + ".json")
        case 3:
            last    = String(split.suffix(1).joined(separator: [" "]))
            first = String(split.prefix(upTo: 2).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + last + "/" + first.replacingOccurrences(of: " ", with: "_") + ".json")
        default:
            first = String(split.prefix(upTo: 1).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + first + ".json")
            print("ERROR: Please include a state or country")
            cityInput.text = "Please include a state or country"
        }
        weatherOutput.text = url?.absoluteString
        
        //print(last + "/" + first)
    }
    
    // MARK: - Get Weather - Current - Parse that shit!
    func findWeather() {
        
        var city = ""
        var temp = 0.0
        var weather = ""
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if let urlContent = data {
                
                DispatchQueue.main.async(execute: {
                    //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                })
                
                //print(urlContent)
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    print("jsonResult:  \(jsonResult)")
                    
                    if let current = jsonResult["current_observation"] as? NSDictionary {
                        print("Current: \(current)")
                        if let display_location = current["display_location"] as? NSDictionary  {
                            print("display_location: \(display_location)")
                            if let fullCity = display_location["full"]{
                                print("fullCity: \(fullCity)")
                                city = fullCity as! String
                            }
                            if let temps = current["temp_f"]  {
                                print("temp: \(temps)")
                                temp = temps as! Double
                            }
                            if let weathers = current["weather"]  {
                                print("weather: \(weathers)")
                                weather = weathers as! String
                                
                            }
                            DispatchQueue.main.async(execute: {
                                self.weatherReport.text  = "Weather Report for \(city) \(temp) \(weather)"
                            })
                        }
                    }
                } catch {
                    
                    print("JSON serialization failed")
                    
                }
            }
        }
        task.resume()
    }

}

