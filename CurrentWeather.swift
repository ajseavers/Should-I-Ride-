//
//  CurrentWeather.swift
//  Stormy
//
//  Created by Andy Seavers on 12/11/15.
//  Copyright © 2015 Andy Seavers. All rights reserved.
//

import Foundation

struct CurrentWeather {
    
    let temperature: Int?
    let temperatureMin: Int?
    //let humidity: Int?
    let precipProbability: Int?
    //let summary: String?
    
    init(weatherDictionary: [String: AnyObject]) {
        if let temperatureFloat = weatherDictionary["temperature"] as? Int {
            temperature = Int(temperatureFloat)
        } else {
            temperature = nil
        }
        
        //if let humidityFloat = weatherDictionary["humidity"] as? Double {
        //    humidity = Int(humidityFloat * 100)
        //} else {
        //    humidity = nil
        //}
        if let precipFloat = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipFloat * 100)
        } else {
            precipProbability = nil
        }
        //summary = weatherDictionary["summary"] as? String
        temperatureMin = weatherDictionary["temperatureMin"] as? Int
    }
}
