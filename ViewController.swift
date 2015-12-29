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




class ViewController: UIViewController, CLLocationManagerDelegate {

//UI Label

    @IBOutlet weak var yesOrNofunction: UILabel!
    @IBOutlet weak var temperatureSliderLabel: UILabel!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var precipSlider: UISlider!
    @IBOutlet weak var precipSliderLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentPrecipitationLabel: UILabel!
    
//Key Variables
    let locationManager = CLLocationManager()
    var coordinate: (lat: Double, long: Double) = (0.0,0.0)
    var complete: String = ""
    var dailyTemperatureLow = 50
    let secondView = SecondViewController()
    var currentTemperature: Int! = 50
    var currentTemperatureSlider: Int! = 50
    var currentPrecip: Int! = 0
    var currentPrecipSlider: Int! = 20
    
//Actions
    @IBAction func valueChangedTemperatureSlider(sender: AnyObject) {
        let currentValueOfTemperatureSlider = Int(temperatureSlider.value)
        temperatureSliderLabel.text = "\(currentValueOfTemperatureSlider)º"
        self.currentTemperatureSlider = currentValueOfTemperatureSlider
    }
    @IBAction func valueChangePrecipSlider(sender: AnyObject) {
        let currentValueOfPrecipSlider = Int((precipSlider.value)*100)
        if currentValueOfPrecipSlider <= 5 {
            precipSliderLabel.text = "I Don't Ride When It Rains"
        } else if (currentValueOfPrecipSlider > 5) && (currentValueOfPrecipSlider < 30) {
            precipSliderLabel.text = "I Sometimes Ride When It Rains"
        } else if (currentValueOfPrecipSlider >= 30) && (currentValueOfPrecipSlider < 75) {
            precipSliderLabel.text = "I Usually Ride When It Rains"
        } else {
            precipSliderLabel.text = "I Always Ride When It Rains"
        }
    
        //precipSliderLabel.text = "\(currentValueOfPrecipSlider)%"
        self.currentPrecipSlider = currentValueOfPrecipSlider
    }
    @IBAction func shouldIRideButton(sender: UIButton) {
        locationManager.startUpdatingLocation()
        locationManager.stopUpdatingLocation()
    }
    
//API Key
    private let forecastAPIKey = "71d16b9db12cf1de20314d764601478f"
    

    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        //locationManager.startUpdatingLocation()
        //locationManager.stopUpdatingLocation()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        self.latitudeLabel.text = "\(userLocation.coordinate.latitude)"
        self.longitudeLabel.text = "\(userLocation.coordinate.longitude)"
        self.coordinate = (userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        coordinate.lat = userLocation.coordinate.latitude
        coordinate.long = userLocation.coordinate.longitude
        print("Your current Location is: \(coordinate)")
        getWeather()
    }

    func getWeather() {
        let forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getForecast(coordinate.lat, long: coordinate.long) {
            (let currently) in
            if let currentWeather = currently {
                //update UI
                dispatch_async(dispatch_get_main_queue()) {
                    //execute closure
                    if let temperature = currentWeather.temperature {
                        self.currentTemperatureLabel?.text = "\(temperature)º"
                        let value = temperature
                        self.currentTemperature = value
                    }
                    if let precipitation = currentWeather.precipProbability {
                        self.currentPrecipitationLabel?.text = "\(precipitation)%"
                        let value = precipitation
                        self.currentPrecip = value
                    }
                    if let temperatureLow = currentWeather.temperatureMin {
                        let value = temperatureLow
                        self.dailyTemperatureLow = value
                        print("The Low is: \(currentWeather.temperatureMin)")
                    }
                }
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SubmitSegue" {
            if let svc = segue.destinationViewController as? SecondViewController {
                if (currentTemperatureSlider <= currentTemperature) && (currentPrecipSlider <= currentPrecip) && (currentTemperatureSlider <= (dailyTemperatureLow + 20))
                {
                    print("It's a great day to ride")
                    shouldPerformSegueWithIdentifier("SumitSegue", sender: self)
                    svc.data = "Yes"
                } else { print("Don't ride today")
                }
            }
        }
    }
}

