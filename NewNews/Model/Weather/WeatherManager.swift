//
//  WeatherManager.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    
    var weatherDelegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=e04ea9586936265be7e8a6dbdd410773&units=metric"
    
    func getWeatherByCity(city: String) {
        let urlString = weatherURL + "&q=\(city)"
        guard let url = URL(string: urlString) else {return}
        sessionTask(url: url)
    }
    
    func getWeatherByLocation(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = weatherURL + "&lat=\(lattitude)&lon=\(longitude)"
        guard let url = URL(string: urlString) else {return}
        sessionTask(url: url)
    }
    
    func sessionTask(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print((error?.localizedDescription)!)
                return
            }
            if let data = data {
                if let weather = self.parseJSON(weatherData: data) {
                    weatherDelegate?.didUpdateWeather(weatherManager: self, weather: weather)
                }
                return
            }
        }
        task.resume()
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel? {
        do {
            let jsonData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            let name = jsonData.name
            let temp = jsonData.main.temp
            let id = jsonData.weather[0].id
            let description = jsonData.weather[0].description
            let feelsTemp = jsonData.main.feels_like
            let humidity = jsonData.main.humidity
            let wind = jsonData.wind.speed
            let windDegrees = jsonData.wind.deg
            let update = jsonData.dt
            let sunset = jsonData.sys.sunset
            let sunrise = jsonData.sys.sunrise
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, weatherDescription: description, feelsLikeTemperature: feelsTemp, airHumidity: humidity, windSpeed: wind, windDegrees: windDegrees, lastUpdate: update, sunset: sunset, sunrise: sunrise)
            print(weather)
            return weather
        } catch {
            print("ERROR:::", error)
            return nil
        }
    }
}
