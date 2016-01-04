//
//  ForecastService.swift
//  Stormy
//
//  Created by Andy Seavers on 12/15/15.
//  Copyright © 2015 Andy Seavers. All rights reserved.
//

import Foundation

struct ForecastService {
    
    var forecastAPIKey = String()
    var forecastBaseURL = NSURL?()
    
    init(APIKey: String) {
        forecastAPIKey = APIKey
        forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(forecastAPIKey)/")
    }
    
    func getForecast (lat: Double, long: Double, completion: (CurrentWeather?) -> ()) {
        if let forecastURL = NSURL(string: "\(lat),\(long)", relativeToURL: forecastBaseURL) {
            
            let networkOperations = NetworkOperation(url: forecastURL)
            
            networkOperations.downloadJSONFromURL {
                (let JSONDictionary) in
                
                let theCurrentWeather = self.currentWeatherFromJSON(JSONDictionary)
                completion(theCurrentWeather)
            }
        } else { print ("Could not construct valid URL")
        }
    }
    
    
    func currentWeatherFromJSON(jsonDictionary: [String: AnyObject]?) -> CurrentWeather? {
        if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String: AnyObject] {
            
            return CurrentWeather(weatherDictionary: currentWeatherDictionary)
            
        } else {
            print("JSON dictionary returned nil for 'currently' key")
            return nil
        }
    }
    
    
}