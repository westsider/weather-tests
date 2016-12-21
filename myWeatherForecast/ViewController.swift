//
//  ViewController.swift
//  myWeatherForecast
//
//  Created by Warren Hansen on 12/17/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//
//  test get location by venice ca and GPS activity indicator
//  test get forecast activity indicator
//  find the api for forecast.. not very accurate, move on to gps request
//  activity indicator durring searc
//  show location derrived from gps
//  develope UI

//  populate UI
//  eneter a date
//  show that date
//  show date + 3 days
//  move to own file and class:     findOnMap(input: cityInput.text!)   findWeather()     getForecast()

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var cityInput: UISearchBar!
    
    @IBOutlet weak var forecastOutput: UITextView!
    
    @IBOutlet weak var locationActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var weathyerActivity: UIActivityIndicatorView!
    
    // current conditions text
    
    @IBOutlet weak var currentState: UILabel!
    
    @IBOutlet weak var currentTemp: UILabel!
    
    @IBOutlet weak var currentConditions: UILabel!
    
    // forecast text
    
    @IBOutlet weak var forecastOneDay: UILabel!
    
    @IBOutlet weak var forecastOneIcon: UIImageView!
    
    @IBOutlet weak var forecastOneHiLo: UILabel!
    
    @IBOutlet weak var forecastOneConditions: UILabel!
    
    //-----
    
    @IBOutlet weak var forecastTwoDay: UILabel!
    
    @IBOutlet weak var forecastTwoIcon: UIImageView!
    
    @IBOutlet weak var forecastTwoHiLo: UILabel!
    
    @IBOutlet weak var forecastTwoCond: UILabel!
    
    //----
    
    @IBOutlet weak var forecastThreeDay: UILabel!
    
    @IBOutlet weak var forecastThreeIcon: UIImageView!
    
    @IBOutlet weak var forecastThreeHiLo: UILabel!
    
    @IBOutlet weak var forecastThreeCond: UILabel!
    
    var url = NSURL(string: "https://api.wunderground.com/api")
    
    var forcastURL = NSURL(string: "api.openweathermap.org/data/2.5/forecast/q={city name},{country code}&cnt={cnt}")
    
    var apiHeader = "https://api.wunderground.com/api/f6373e95fa296c84/"
    
    var count = "2"
    
    let locationManager = CLLocationManager()
    
    var lat = "0000"
    
    var long = "-0000"
    
    var latLong = ""
    
    // this is my current weather api call
    //  https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/CA/Venice.json
    
    //  this works for 10 day forecast
    //  https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/CA/Venice.json
    
    //  this will auto query ip location
    //  https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/autoip.json
    
    // this will use gps to get 10 day forecast
    //  https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/lat=37.785834&lon=-122.406417.json
    
    // this will use gps to get 3 day forecast
    //  https://api.wunderground.com/api/f6373e95fa296c84/forecast7day/q/lat=37.785834&lon=-122.406417.json
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityInput.text = "Festus MO"
        locationManager.requestAlwaysAuthorization()
    }


    @IBAction func searchAction(_ sender: Any) {
        findOnMap(input: cityInput.text!)
        findWeather()
    }
    
    @IBAction func forecastAction(_ sender: Any) {
        getForecast()
    }

    // MARK: - Find my location
    func findMyLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationActivity.stopAnimating()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        lat = "\(coord.latitude)"
        long = "\(coord.longitude)"
        latLong = "\(lat)\(long)"
        print(latLong)
        forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast7day/q/lat=\(lat)&lon=-\(long).json")
        locationManager.stopUpdatingLocation()

        CLGeocoder().reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    
                    self.cityInput.text = placemark.locality! + " " + placemark.administrativeArea! // or loctio
                } else {
                    self.cityInput.text = "No Matching Addresses Found"
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error While Updating Location: \(error.localizedDescription)")
    }
    
    // MARK: - Parse Location
    func findOnMap(input: String) {
        let location = cityInput.text!
        let str = location
        let split = str.characters.split(separator: " ")
        let size = split.count
        var last = ""
        var first = ""
        
        locationActivity.startAnimating()
        
        switch size {
        case 0:
            self.findMyLocation()
            cityInput.text = "Finding Location Based on GPS"
        case 2:
            last    = String(split.suffix(1).joined(separator: [" "]))
            first = String(split.prefix(upTo: 1).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + last + "/" + first + ".json")
            forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast/q/" + last + "/" + first + ".json")
        case 3:
            last    = String(split.suffix(1).joined(separator: [" "]))
            first = String(split.prefix(upTo: 2).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + last + "/" + first.replacingOccurrences(of: " ", with: "_") + ".json")
            forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast/q/" + last + "/" + first.replacingOccurrences(of: " ", with: "_") + ".json")
            
        default:
            first = String(split.prefix(upTo: 1).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + first + ".json")
            forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast/q/" + first + ".json")
            //  print("ERROR: Please include a state or country")
            cityInput.text = "Please include a state or country"
        }
    }
    
    // MARK: - Get Weather - Current weather OR city and Parse
    func findWeather() {
        
        var thisCity = ""
        var thisState = ""
        var countryCode = ""
        var temp = 0.0
        var weather = ""
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if let urlContent = data {
                
                DispatchQueue.main.async(execute: {
                    self.locationActivity.stopAnimating()
                    //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                })
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                      // print("jsonResult:  \(jsonResult)")
                    
                    if let current = jsonResult["current_observation"] as? NSDictionary {
                        //  print("Current: \(current)")
                        if let display_location = current["display_location"] as? NSDictionary  {
                            //  print("display_location: \(display_location)")
                            if let city = display_location["city"]{
                                //  print("fullCity: \(fullCity)")
                                thisCity = city as! String
                            }
                            if let state = display_location["state"]{
                                //  print("fullCity: \(fullCity)")
                                thisState = state as! String
                            }
                            if let country = display_location["country_iso3166"]{
                                  //    print("countryCode: \(country)")
                                countryCode = country as! String
                            }
                            if let temps = current["temp_f"]  {
                                //  print("temp: \(temps)")
                                temp = temps as! Double
                            }
                            if let weathers = current["weather"]  {
                                //  print("weather: \(weathers)")
                                weather = weathers as! String
                            }
                            
                            DispatchQueue.main.async(execute: {
                               //self.weatherReport.text  = "\(thisCity) \(thisState) \n\(countryCode)\n\n Currently \n\(temp)°\n\(weather)"
                                
                                self.currentState.text = thisCity.uppercased()
                                
                                self.currentTemp.text = "\(temp)°"
                                
                                self.currentConditions.text = weather
                                
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
    
    @IBOutlet weak var forecastAction: UIButton!
    
    // MARK: - Get Weather - Forecast
    // how do I enter the date?
    func getForecast() {
        
        weathyerActivity.startAnimating()
        
        let task = URLSession.shared.dataTask(with: forcastURL! as URL) {(data, response, error) in
            
            let json: [String: Any]?
            
            do {
                json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                } catch {
                json = nil
                print("Error is \(error.localizedDescription)")
                }
            
            var forecastString = "" // to display and prove data not for final UI
            
            // weather detail object
            if  let forecastDetail = ForecastDetail.forecastDetialArray(json: json!) {
                
                var  dateArray:[String] = [" "]
                
                var dateDetailArray:[[String]] = [[" "]]
                
                var dateDeats:[String] = [" "]
                
                var i = 0
                
                for element in forecastDetail {
                    
                    // date object array
                    let forecastDate = ForecastDate.forecastDateArray(json: json!)
                    let this = (forecastDate?[i].weekdayShort)! as String
                    
                    forecastString += this + " " +  element.low + " " + element.high + " " + element.conditions + "\n"
                    
                    //dateArray.append(forecastString)
                    
                    dateDeats.removeAll()

                    dateDeats.append(this)
                    dateDeats.append(element.low)
                    dateDeats.append(element.high)
                    dateDeats.append(element.conditions)
                    //  dateDeats.append(element.icon)      // change arrays to anyobject first || create image array
                    dateDetailArray.append(dateDeats)
                    
                     i = i + 1
                }
                
                // populate forecast with data from json
                
                dateDetailArray.remove(at: 0)
                print(dateDetailArray)
                
                dateArray.remove(at: 0)
                DispatchQueue.main.async(execute: {
                    self.forecastOutput.text = forecastString
                    self.weathyerActivity.stopAnimating()
                    
                    // TODO: - use date detail array in UI forecast
                    
                    self.forecastOneDay.text = dateDetailArray[0][0]
                    
                     //self.forecastOneIcon.text = dateDetailArray[0][1]
                    
                    self.forecastOneHiLo.text = dateDetailArray[0][1] + "°" + " / " + dateDetailArray[0][2] + "°"
                    
                    self.forecastOneConditions.text = dateDetailArray[0][3]
                    
                    //-----
                    
                    self.forecastTwoDay.text = dateDetailArray[1][0]
                    
                    //@IBOutlet weak var forecastTwoIcon: UIImageView!
                    
                    self.forecastTwoHiLo.text = dateDetailArray[1][1] + "°" + " / " + dateDetailArray[1][2] + "°"
                    
                    self.forecastTwoCond.text = dateDetailArray[1][3]
                    
                    //----
                    
                    self.forecastThreeDay.text = dateDetailArray[2][0]
                    
                   // @IBOutlet weak var forecastThreeIcon: UIImageView!
                    
                    self.forecastThreeHiLo.text = dateDetailArray[2][1] + "°" + " / " + dateDetailArray[2][2] + "°"
                    
                    self.forecastThreeCond.text = dateDetailArray[2][3]
                    
                    // TODO: - get icon of conditions from json
                    // TODO: - use date to display corrent forecast and current conditions
                    // TODO: - call forecast after location aquired
                    
                })
            }

        }
        task.resume()
    }
}

