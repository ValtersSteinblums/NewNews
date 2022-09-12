//
//  WeatherData.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

//import Foundation
//
//struct WeatherData: Codable {
//    let name: String
//    let sys: Sys
//    let main: Main
//    let weather: [Weather]
//    let wind: Wind
//    let dt: Int
//}
//
//struct Main: Codable {
//    let temp: Double
//    let feels_like: Double
//    let humidity: Int
//}
//
//struct Weather: Codable {
//    let id: Int
//    let main: String
//}
//
//struct Wind: Codable {
//    let speed: Double
//    let deg: Int
//}
//
//struct Sys: Codable {
//    let sunrise: Int
//    let sunset: Int
//}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherData = try? newJSONDecoder().decode(WeatherData.self, from: jsonData)

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let list: [List]?
    let city: City?
}

// MARK: - City
struct City: Codable {
//    let id: Int?
    let name: String?
    let coord: Coord?
//    let country: String?
//    let population, timezone, sunrise, sunset: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]?
//    let clouds: Clouds?
    let wind: Wind?
//    let sys: Sys?
//    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
//        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
//struct Clouds: Codable {
//    let all: Int?
//}

// MARK: - Main
struct Main: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double?
    let temp, feelsLike: Double?
//    let pressure, seaLevel, grndLevel, humidity: Int?
    let humidity: Int?
//    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
        case humidity
//        case tempKf = "temp_kf"
    }
}

// MARK: - Sys
//struct Sys: Codable {
//    let pod: String?
//}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
//    let main, weatherDescription, icon: String?
    let main: String?

    enum CodingKeys: CodingKey {
        case id, main
//        case weatherDescription = "description"
//        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
//    let gust: Double?
}




