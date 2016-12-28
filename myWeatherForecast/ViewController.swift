//
//  ViewController.swift
//  myWeatherForecast
//
//  Created by Warren Hansen on 12/17/16.
//  Copyright © 2016 Warren Hansen. All rights reserved.
//
/*
 feat: a new feature
 fix: a bug fix
 docs: changes to documentation
 style: formatting, missing semi colons, etc; no code change
 refactor: refactoring production code
 test: adding tests, refactoring test; no production code change
 chore: updating build tasks, package manager configs, etc; no production code change
 */
//  test get location by venice ca and GPS activity indicator
//  test get forecast activity indicator
//  find the api for forecast.. not very accurate, move on to gps request
//  activity indicator durring searc
//  show location derrived from gps
//  develope UI
//  populate UI
//  call forecast after location aquired
//  missing if location not found
//  add date picker
//  calc todays date - picker date: for days in the future
//  chance forcast day to num in array
//  update forcast when picker moves
//  show short date on forecast
//  stack view for weather

//  move to own file and class:     findOnMap(input: cityInput.text!)   findWeather()     getForecast()

import UIKit
import CoreLocation

class ViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var cityInput: UISearchBar!
    
    @IBOutlet weak var locationActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var weathyerActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    
    // current conditions text
    
    @IBOutlet weak var currentState: UILabel!
    
    @IBOutlet weak var currentTemp: UILabel!
    
    @IBOutlet weak var currentConditions: UILabel!
    
    // forecast text day 1
    
    @IBOutlet weak var forecastOneDay: UILabel!
    
    @IBOutlet weak var forecastOneIcon: UIImageView!
    
    @IBOutlet weak var forecastOneHiLo: UILabel!
    
    @IBOutlet weak var forecastOneConditions: UILabel!
    
    //----- day 2
    
    @IBOutlet weak var forecastTwoDay: UILabel!
    
    @IBOutlet weak var forecastTwoIcon: UIImageView!
    
    @IBOutlet weak var forecastTwoHiLo: UILabel!
    
    @IBOutlet weak var forecastTwoCond: UILabel!
    
    //---- day 3
    
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
    
    var pickedDate = Date()
    
    var NumOfDays = 1
    
    var datePickerUtility = DatePickerUtility()

    
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
        cityInput.text = "Los Angeles CA"
        locationManager.requestAlwaysAuthorization()
    }
    
    //  MARK: - Update Button: Takes GPS or City, State and finds weather forecast
    @IBAction func searchAction(_ sender: Any) {
        findOnMap(input: cityInput.text!)
    }
    
    // MARK: - Add Date Picker View
    @IBAction func dateTextEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    // format the selected Date and update vars used in weather forcast
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField.text = dateFormatter.string(from: sender.date)
        
        // update vars used in weather forcast
        pickedDate =  sender.date
        
        NumOfDays = datePickerUtility.daysBetweenDates(startDate: Date(), endDate: pickedDate) + 1
        
        print("Num of Days: \(NumOfDays)")
    }
    
    // MARK: Touch Events: close keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // TODO: - Refactor -------------------------------------------------------------------------------------------------------
    // MARK: - Find my location using GPS
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
        forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/lat=\(lat)&lon=-\(long).json")
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(locationObj, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    
                    self.cityInput.text = placemark.locality! + " " + placemark.administrativeArea! // or loction
                    self.findOnMap(input: self.cityInput.text!)
                    //self.findWeather()
                } else {
                    self.cityInput.text = "No Matching Addresses Found"
                }
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error While Updating Location: \(error.localizedDescription)")
    }
    
    // TODO: - Refactor -------------------------------------------------------------------------------------------------------
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
            forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/" + last + "/" + first + ".json")
            self.findWeather()
        case 3:
            last    = String(split.suffix(1).joined(separator: [" "]))
            first = String(split.prefix(upTo: 2).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + last + "/" + first.replacingOccurrences(of: " ", with: "_") + ".json")
            forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/" + last + "/" + first.replacingOccurrences(of: " ", with: "_") + ".json")
            self.findWeather()
            
        default:
            first = String(split.prefix(upTo: 1).joined(separator: [" "]))
            url = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/conditions/q/" + first + ".json")
            forcastURL = NSURL(string: "https://api.wunderground.com/api/f6373e95fa296c84/forecast10day/q/" + first + ".json")
            //  print("ERROR: Please include a state or country")
            cityInput.text = "Please include a state or country"
        }
    }
    
    // TODO: - Refactor -------------------------------------------------------------------------------------------------------
    // MARK: - Get Weather - Current weather OR city and Parse
    func findWeather() {
        
        var thisCity = ""
        var thisState = ""
        var countryCode = ""
        var temp = 0.0
        var weather = ""
        
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            
            if let urlContent = data {
                
                if error != nil {
                    
                    print("error: \(error)")
                    
                }
                
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
                                
                                self.currentState.text = thisCity.uppercased()
                                
                                self.currentTemp.text = "\(temp)°"
                                
                                self.currentConditions.text = weather
                                
                                self.getForecast()
                            })
                        }
                    } else {
                        print("City Not Found!")
                        DispatchQueue.main.async(execute: {
                            self.currentState.text = "ERROR"
                        
                            self.currentTemp.text = "⚠️"
                        
                            self.currentConditions.text = "Unknown Places"
                        })
                    }
                } catch {
                    print("JSON serialization failed")
                }
            }
        }
        task.resume()
    }
    
    // TODO: - Refactor -------------------------------------------------------------------------------------------------------
    // MARK: - Forecast
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
            
            // weather detail object
            if  let forecastDetail = ForecastDetail.forecastDetialArray(json: json!) {
                
                var dateDetailArray:[[String]] = [[" "]]
                
                var dateDeats:[String] = [" "]
                
                var i = 0
                
                dateDetailArray.removeAll()
                
                for element in forecastDetail {
                    
                    // date object array
                    let forecastDate = ForecastDate.forecastDateArray(json: json!)
                    let this = (forecastDate?[i].weekdayShort)! as String
                    dateDeats.removeAll()
                    dateDeats.append(this)
                    dateDeats.append(element.icon)      // change arrays to anyobject first || create image array
                    dateDeats.append(element.low)
                    dateDeats.append(element.high)
                    dateDeats.append(element.conditions)
                    
                    dateDetailArray.append(dateDeats)
                    
                    i = i + 1
                }
                
                // MARK: - Limit forecast to 10 days
                if self.NumOfDays >= 10 { self.NumOfDays = 7 }
                // if num days neg then make 0
                if self.NumOfDays < 0 { self.NumOfDays = 0 }
 
                // MARK: - use date detail array in UI forecast
                
                print(dateDetailArray)
                
                DispatchQueue.main.async(execute: {
                    
                    self.weathyerActivity.stopAnimating()
                    
                    print("Num Days: \(self.NumOfDays)")
                    
                    self.forecastOneDay.text = self.datePickerUtility.numOfDaysToShortDate(numOfDays: self.NumOfDays)
                    
                    self.forecastOneIcon.image =  setIcon(input: dateDetailArray[0 + self.NumOfDays ][1])
                    
                    self.forecastOneHiLo.text = (dateDetailArray[0 + self.NumOfDays ][2]) + "°" + " / " + (dateDetailArray[0][3] ) + "°"
                    
                    self.forecastOneConditions.text = dateDetailArray[0 + self.NumOfDays ][4]
                    
                    //-----
                    
                    self.forecastTwoDay.text = self.datePickerUtility.numOfDaysToShortDate(numOfDays: self.NumOfDays + 1)
                    
                    self.forecastTwoIcon.image = setIcon(input: dateDetailArray[1 + self.NumOfDays ][1])
                    
                    self.forecastTwoHiLo.text = (dateDetailArray[1 + self.NumOfDays ][2]) + "°" + " / " + (dateDetailArray[1 + self.NumOfDays ][3]) + "°"
                    
                    self.forecastTwoCond.text = dateDetailArray[1 + self.NumOfDays ][4]
                    
                    //----
                    
                    self.forecastThreeDay.text = self.datePickerUtility.numOfDaysToShortDate(numOfDays: self.NumOfDays + 2)
                    
                    self.forecastThreeIcon.image = setIcon(input: dateDetailArray[2 + self.NumOfDays ][1])
                    
                    self.forecastThreeHiLo.text = (dateDetailArray[2 + self.NumOfDays ][2]) + "°" + " / " + (dateDetailArray[2 + self.NumOfDays ][3]) + "°"
                    
                    self.forecastThreeCond.text = dateDetailArray[2 + self.NumOfDays ][4]
                    
                })
            }
            
        }
        task.resume()
    }
}




