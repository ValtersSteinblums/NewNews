//
//  WeatherData.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let sys: Sys
    let main: Main
    let weather: [Weather]
    let wind: Wind
    let dt: Int
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Sys: Codable {
    let sunrise: Int
    let sunset: Int
}



