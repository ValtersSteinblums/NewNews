//
//  DetailWeatherViewController.swift
//  NewNews
//
//  Created by valters.steinblums on 04/09/2022.
//

import UIKit
import CoreLocation

class DetailWeatherViewController: UIViewController {
    
    var weatherList: [List] = []
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureFeelsLikeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherImageTwo: UIImageView!
    @IBOutlet weak var weatherImageThree: UIImageView!
    @IBOutlet weak var weatherImageFour: UIImageView!
    @IBOutlet weak var temperatureLabelTwo: UILabel!
    @IBOutlet weak var temperatureLabelThree: UILabel!
    @IBOutlet weak var temperatureLabelFour: UILabel!
    @IBOutlet weak var forecastTimeOne: UILabel!
    @IBOutlet weak var forecastTimeTwo: UILabel!
    @IBOutlet weak var forecastTimeThree: UILabel!
    
    
    
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
            //weatherManager.getWeatherByCity(city: city)
            weatherManager.getWeatherByCity(city: city) { list in
                self.weatherList = list
            }
        }
        searchTextField.text = ""
    }
}

extension DetailWeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
//            self.weatherImage.image = UIImage(named: weather.conditionName)
//            self.weatherDescriptionLabel.text = weather.weatherDescription
//            self.temperatureLabel.text = "\(weather.temperatureString)°C"
//            self.cityLabel.text = weather.cityName
//            self.temperatureFeelsLikeLabel.text = "Feels like \(weather.feelsLikeTemperatureString)°C"
//            self.humidityLabel.text = "Humidity: \(weather.airHumidity.description)%"
//            self.windSpeedLabel.text = "Wind: \(weather.windSpeed.description)m/s Direction: \(weather.windDirection)"
//            self.lastUpdateLabel.text = "Last updated: \(weather.lastUpdateToDate.description)"
            self.weatherImage.image = UIImage(named: weather.conditionName(conditionID: weather.conditionID))
            self.weatherDescriptionLabel.text = weather.weatherDescription
            self.temperatureLabel.text = "\(weather.temperatureString(temp: weather.temperature))°C"
            self.cityLabel.text = weather.cityName
            self.temperatureFeelsLikeLabel.text = "Feels like \(weather.feelsLikeTemperatureString)°C"
            self.humidityLabel.text = "Humidity: \(weather.airHumidity.description)%"
            self.windSpeedLabel.text = "Wind: \(weather.windSpeed.description)m/s Direction: \(weather.windDirection)"
            self.lastUpdateLabel.text = "Last updated: \(weather.lastUpdateToDate.description)"
            
            self.weatherImageTwo.image = UIImage(named: weather.conditionName(conditionID: weather.secondConditionID))
            self.weatherImageThree.image = UIImage(named: weather.conditionName(conditionID: weather.thirdConditionID))
            self.weatherImageFour.image = UIImage(named: weather.conditionName(conditionID: weather.fourthConditionID))
            self.temperatureLabelTwo.text = weather.temperatureString(temp: weather.secondTemp)
            self.temperatureLabelThree.text = weather.temperatureString(temp: weather.thirdTemp)
            self.temperatureLabelFour.text = weather.temperatureString(temp: weather.fourthTemp)
            self.forecastTimeOne.text = weather.forecastedTime(time: weather.forecastOne)
            self.forecastTimeTwo.text = weather.forecastedTime(time: weather.forecastTwo)
            self.forecastTimeThree.text = weather.forecastedTime(time: weather.forecastThree)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension DetailWeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.showSpinner()
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //weatherManager.getWeatherByLocation(lattitude: lat, longitude: lon)
            weatherManager.getWeatherByLocation(latitude: lat, longitude: lon) { list in
                self.weatherList = list
            }
            self.removeSpinner()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
