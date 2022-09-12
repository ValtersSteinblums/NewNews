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
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?&appid=e04ea9586936265be7e8a6dbdd410773&units=metric&cnt=4"
    
    func getWeatherByCity(city: String, completion: @escaping([List]) -> ()) {
        let urlString = weatherURL + "&q=\(city)"
        print(urlString)
        guard let url = URL(string: urlString) else {return}
        sessionTask(url: url, completion: completion)
    }
    
    func getWeatherByLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping([List]) -> ()) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&cnt=4"
        guard let url = URL(string: urlString) else {return}
        print(urlString)
        sessionTask(url: url, completion: completion)
    }
    
    func sessionTask(url: URL, completion: @escaping([List]) -> ()) {
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
            print(jsonData)
            let name = jsonData.city?.name
            let temp = jsonData.list?[0].main?.temp
            let id = jsonData.list?[0].weather?[0].id
            
            let temp1 = jsonData.list?[1].main?.temp
            let id1 = jsonData.list?[1].weather?[0].id
            let temp2 = jsonData.list?[2].main?.temp
            let id2 = jsonData.list?[2].weather?[0].id
            let temp3 = jsonData.list?[3].main?.temp
            let id3 = jsonData.list?[3].weather?[0].id
            let forecast1 = jsonData.list?[1].dt
            let forecast2 = jsonData.list?[2].dt
            let forecast3 = jsonData.list?[3].dt

            let desc = jsonData.list?[0].weather?[0].main
            let feelsLike = jsonData.list?[0].main?.feelsLike
            let humidity = jsonData.list?[0].main?.humidity
            let windSpeed = jsonData.list?[0].wind?.speed
            let windDeg = jsonData.list?[0].wind?.deg
            let update = jsonData.list?[0].dt
            
            
            let weather = WeatherModel(conditionID: id!, cityName: name!, temperature: temp!, weatherDescription: desc!, feelsLikeTemperature: feelsLike!, airHumidity: humidity!, windSpeed: windSpeed!, windDegrees: windDeg!, lastUpdate: update!, secondTemp: temp1!, secondConditionID: id1!, thirdTemp: temp2!, thirdConditionID: id2!, fourthTemp: temp3!, fourthConditionID: id3!, forecastOne: forecast1!, forecastTwo: forecast2!, forecastThree: forecast3!)
            print(weather)
            return weather
        } catch {
            print("ERROR:::", error)
            return nil
        }
    }
}

//struct WeatherManager {
//
//    var weatherDelegate: WeatherManagerDelegate?
//
//    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=e04ea9586936265be7e8a6dbdd410773&units=metric"
//
//    func getWeatherByCity(city: String) {
//        let urlString = weatherURL + "&q=\(city)"
//        guard let url = URL(string: urlString) else {return}
//        sessionTask(url: url)
//    }
//
//    func getWeatherByLocation(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let urlString = weatherURL + "&lat=\(lattitude)&lon=\(longitude)"
//        guard let url = URL(string: urlString) else {return}
//        sessionTask(url: url)
//    }
//
//    func sessionTask(url: URL) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard error == nil else {
//                print((error?.localizedDescription)!)
//                return
//            }
//            if let data = data {
//                if let weather = self.parseJSON(weatherData: data) {
//                    weatherDelegate?.didUpdateWeather(weatherManager: self, weather: weather)
//                }
//                return
//            }
//        }
//        task.resume()
//    }
//
//    func parseJSON(weatherData: Data) -> WeatherModel? {
//        do {
//            let jsonData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
//            print(jsonData)
//            let name = jsonData.name
//            let temp = jsonData.main.temp
//            let id = jsonData.weather[0].id
//            let description = jsonData.weather[0].main
//            let feelsTemp = jsonData.main.feels_like
//            let humidity = jsonData.main.humidity
//            let wind = jsonData.wind.speed
//            let windDegrees = jsonData.wind.deg
//            let update = jsonData.dt
//
//            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, weatherDescription: description, feelsLikeTemperature: feelsTemp, airHumidity: humidity, windSpeed: wind, windDegrees: windDegrees, lastUpdate: update)
//            print(weather)
//            return weather
//        } catch {
//            print("ERROR:::", error)
//            return nil
//        }
//    }
//}
