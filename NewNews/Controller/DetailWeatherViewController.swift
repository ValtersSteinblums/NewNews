//
//  DetailWeatherViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

import UIKit
import CoreLocation

class DetailWeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureFeelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        
        weatherManager.weatherDelegate = self
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func refreshMyLoactionPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

// MARK: - UITextFieldDelegate
extension DetailWeatherViewController: UITextFieldDelegate {
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something..."
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.getWeatherByCity(city: city)
        }
        searchTextField.text = ""
    }
}

extension DetailWeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.weatherDescriptionLabel.text = weather.weatherDescription
            self.temperatureLabel.text = "\(weather.temperatureString)°C"
            self.cityLabel.text = weather.cityName
            self.temperatureFeelsLikeLabel.text = "Feels like \(weather.feelsLikeTemperatureString)°C"
            self.humidityLabel.text = "Humidity: \(weather.airHumidity.description)%"
            self.windSpeedLabel.text = "Wind: \(weather.windSpeed.description)m/s Direction:\(weather.windDirection)"
            self.sunriseLabel.text = "Sunrise: \(weather.sunriseToDate.description)"
            self.sunsetLabel.text = "Sunset: \(weather.sunsetToDate.description) "
            self.lastUpdateLabel.text = "Last updated: \(weather.lastUpdateToDate.description)"
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension DetailWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getWeatherByLocation(lattitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
