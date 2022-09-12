//
//  WeatherModel.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let weatherDescription: String
    let feelsLikeTemperature: Double
    let airHumidity: Int
    let windSpeed: Double
    let windDegrees: Int
    let lastUpdate: Int
    
    let secondTemp: Double
    let secondConditionID: Int
    let thirdTemp: Double
    let thirdConditionID: Int
    let fourthTemp: Double
    let fourthConditionID: Int
    
    let forecastOne: Int
    let forecastTwo: Int
    let forecastThree: Int
    
    func temperatureString(temp: Double) -> String {
        return String(format: "%.1f", temp)
    }
    
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }
    
    var lastUpdateToDate: String {
        let lastUpdate = Date(timeIntervalSince1970: TimeInterval(lastUpdate))
        let timeLastUpdate = lastUpdate.dateToString(dateFormat: "yyyy.MM.dd HH:mm:ss")
        return timeLastUpdate
    }
    
    func forecastedTime(time: Int) -> String {
        let forecast = Date(timeIntervalSince1970: TimeInterval(time))
        let forecastTime = forecast.dateToString(dateFormat: "yyyy.MM.dd\nHH:mm:ss")
        return forecastTime
    }
    
    var windDirection: String {
        switch windDegrees {
        case 11...79:
            return "NE"
        case 79...124:
            return "E"
        case 125...169:
            return "SE"
        case 170...213:
            return "S"
        case 214...258:
            return "SW"
        case 259...303:
            return "W"
        case 304...348:
            return "NW"
        default:
            return "N"
        }
    }
    
    func conditionName(conditionID: Int) -> String {
        switch conditionID {
        case 0...300 :
            return "storm"
        case 301...500 :
            return "rainy"
        case 501...600 :
            return "rain"
        case 601...700 :
            return "snow"
        case 701...771 :
            return "foggy"
        case 772...799 :
            return "thunderstorm"
        case 800 :
            return "sun"
        case 801...804 :
            return "cloudy"
        case 900...903, 905...1000  :
            return "thunderstorm"
        case 903 :
            return "snow"
        case 904 :
            return "sun"
        default:
            return "cloudy"
        }
    }
}
