//
//  ViewController.swift
//  Should I Ride?
//
//  Created by Andy Seavers on 12/15/15.
//  Copyright © 2015 Andy Seavers. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

// Ideas For UI -? Harder, like guitar hero extreme, motorcycle focus.
// Custom Typeface - fontsquirrel.com - montserrat, league spartan
// thicker sliders
// subtle gradient on background
// upcase button
// 
//
// 1. Save NSUSER Default
// 2. Detect 1st Launch
// 3. New UX ->
//              Welcome ->
//              Set Pref. -> Type Rider, Type Motorcycle, Temp, Precip, (Commute, Short Ride, Long Ride).
//              Should I Ride, with menu at top left that slides out.
//
// 4. Apple Watch UX -> shows the should I ride button.

class ViewController: UIViewController, CLLocationManagerDelegate {

//UI Label
    @IBOutlet weak var yesOrNofunction: UILabel!
    @IBOutlet weak var temperatureSliderLabel: UILabel!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var precipSlider: UISlider!
    @IBOutlet weak var precipSliderLabel: UILabel!
    @IBOutlet weak var motorcycleImage: UIImageView!
    @IBOutlet weak var lowThermoImage: UIImageView!
    @IBOutlet weak var thermoImage: UIImageView!
    @IBOutlet weak var stormyImage: UIImageView!
    @IBOutlet weak var sunImage: UIImageView!
    @IBOutlet weak var progressIndicatorCurrentLocation: UIActivityIndicatorView!
    
    
    @IBOutlet var test: [UIImageView]!
    
    
//Key Variables
    let locationManager = CLLocationManager()
    var coordinate: (lat: Double, long: Double) = (0.0,0.0)
    var coordinateCompare: (lat: Double, long: Double) = (0.0,0.0)
    var complete: String = ""
    var dailyTemperatureLow = 50
    let secondView = SecondViewController()
    var currentTemperature: Int = 30
    var currentTemperatureSlider: Int! = 50
    var currentPrecip: Int = 0
    var currentPrecipSlider: Int! = 20

   // let prefs = NSUserDefaults.standardUserDefaults()
    
    
    
//Actions
    // Causes the value of the Temperature Slider to update the value of the temperature slider
    @IBAction func valueChangedTemperatureSlider(sender: AnyObject) {
        let currentValueOfTemperatureSlider = Int(temperatureSlider.value)
        if (currentValueOfTemperatureSlider > -20) && (currentValueOfTemperatureSlider < 69) {
            temperatureSliderLabel.text = "I won't ride under \(currentValueOfTemperatureSlider)º"
        }
        else if (currentValueOfTemperatureSlider == -20) {
            temperatureSliderLabel.text = "It's never too cold to ride!"
        }
        else {
            temperatureSliderLabel.text = "I'm a wimp!"
        }
        self.currentTemperatureSlider = currentValueOfTemperatureSlider
    }
    
    
    // Causes the value of the Precipitation Slider to update the value of your precipitation slider
    @IBAction func valueChangePrecipSlider(sender: AnyObject) {
        let currentValueOfPrecipSlider = Int((precipSlider.value)*100)
        if currentValueOfPrecipSlider <= 15 {
            precipSliderLabel.text = "I don't ride when it rains"
        } else if (currentValueOfPrecipSlider > 15) && (currentValueOfPrecipSlider < 30) {
            precipSliderLabel.text = "I don't like to ride when it rains"
        } else if (currentValueOfPrecipSlider >= 30) && (currentValueOfPrecipSlider < 75) {
            precipSliderLabel.text = "I will sometimes ride when it rains"
        } else {
            precipSliderLabel.text = "I will always ride when it rains"
        }
        self.currentPrecipSlider = currentValueOfPrecipSlider
    }
    
    // Button that transitions to second page
    @IBAction func shouldIRideButton(sender: UIButton) {
        
    }
    
//API Key
    private let forecastAPIKey = "71d16b9db12cf1de20314d764601478f"
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        
         
// Starts running Progress Indicator for current location
        progressIndicatorCurrentLocation.startAnimating()
        


        
// Pulls the user's current location using the locationManager Function
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        shouldPerformSegueWithIdentifier("SubmitSegue", sender: self)
        locationManager.stopUpdatingLocation()
        
               
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//Pulls users current location using CLLocationManager and updates the cooridate variable.  Then runs the getWeather Function.
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        self.coordinate = (userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        self.coordinate.lat = userLocation.coordinate.latitude
        self.coordinate.long = userLocation.coordinate.longitude
        print("Your current Location is: \(coordinate)")
        progressIndicatorCurrentLocation.stopAnimating()
        progressIndicatorCurrentLocation.hidesWhenStopped = true
        getWeather()
        
        
        
    }
    
// uses the NetworkOperation class to pull forecast data from the ForecastService Struct using the user's current location.  For some reason, the current temperature and current precip variables only update correctly when testing on actual iPhone rather than simulated iPhone.
    func getWeather() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, long: coordinate.long) {
            (let currently) in
            if let currentWeather = currently {
                    //execute closure
                if let temperature = currentWeather.temperature {
                    print("Temperature should  be changed to \(temperature)")
                    self.currentTemperature = temperature
                }
                if let precipitation = currentWeather.precipProbability {
                    print("Precipitation should  be changed to \(precipitation)")
                    self.currentPrecip = precipitation
                    }
                if let temperatureLow = currentWeather.temperatureMin {
                    self.dailyTemperatureLow = temperatureLow
                    print("The Low is: \(currentWeather.temperatureMin)")
                    
                }
            } 
        }
    }
    
// Runs this segue when ShouldIRide Button is pressed.  Runs an if statement to confirm that conditions are acceptable for riding.  If all statements are true, the label on the second screen is changed from the word no, to the word yes.
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SubmitSegue" {
            if let svc = segue.destinationViewController as? SecondViewController {
                if (currentTemperatureSlider <= currentTemperature) && (currentPrecipSlider >= currentPrecip) && (currentTemperatureSlider <= (dailyTemperatureLow + 20))
                {
                    print("It's a great day to ride")
                    svc.data = "Yes"
                    
                } else { print("Don't ride today")
                }
            }
        }
    }
}

