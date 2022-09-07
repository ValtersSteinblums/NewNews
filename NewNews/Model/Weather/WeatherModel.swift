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
    let sunset: Int
    let sunrise: Int
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var feelsLikeTemperatureString: String {
        return String(format: "%.1f", feelsLikeTemperature)
    }
    
    var lastUpdateToDate: String {
        let lastUpdate = Date(timeIntervalSince1970: TimeInterval(lastUpdate))
        let timeLastUpdate = lastUpdate.dateToString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        return timeLastUpdate
    }
    
    var sunsetToDate: String {
        let sunSets = Date(timeIntervalSince1970: TimeInterval(sunset))
        let timeSunSets = sunSets.dateToString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        return timeSunSets
    }
    
    var sunriseToDate: String {
        let sunRises = Date(timeIntervalSince1970: TimeInterval(sunrise))
        let timeSunRises = sunRises.dateToString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        return timeSunRises
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
    
    var conditionName: String {
        switch conditionID {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

extension Date {
    func dateToString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toLocaltime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
