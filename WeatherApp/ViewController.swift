//
//  ViewController.swift
//  WeatherApp
//
//  Created by shafique dassu on 14/07/2023.
//

import UIKit
import CoreLocation
import SDWebImage

//iconURL: "https://openweathermap.org/img/wn/" + icon + ".png"
class ViewController: UIViewController {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    func updateWeather(lat: Double, long: Double) {
        ApiManager.shared.getWeather(lat: lat, long: long) { weatherData in
            if let weatherData {
                self.weatherImageView.sd_setImage(with: weatherData.image)
                DispatchQueue.main.async {
                    self.locationLabel.text = weatherData.location
                    self.weatherDescriptionLabel.text = weatherData.description
                }
                let measurement = Measurement(value: weatherData.temp, unit: UnitTemperature.celsius)
                let measurementFormatter = MeasurementFormatter()
                measurementFormatter.unitStyle = .short
                measurementFormatter.numberFormatter.maximumFractionDigits = 0
                measurementFormatter.unitOptions = .temperatureWithoutUnit
                DispatchQueue.main.async {
                    self.temperatureLabel.text = measurementFormatter.string(from: measurement)
                }
                self.humidityLabel.text = String(weatherData.humidity)
            }
        }
    }
    
    func updateWeatherCodable(lat: Double, long: Double) {
        ApiManager.shared.getWeatherCodable(lat: lat, long: long) { weatherData in
            if let weatherData {
                self.weatherImageView.sd_setImage(with: weatherData.image)
                DispatchQueue.main.async {
                    self.locationLabel.text = weatherData.location
                    self.weatherDescriptionLabel.text = weatherData.description
                }
                let measurement = Measurement(value: weatherData.temp, unit: UnitTemperature.celsius)
                let measurementFormatter = MeasurementFormatter()
                measurementFormatter.unitStyle = .short
                measurementFormatter.numberFormatter.maximumFractionDigits = 0
                measurementFormatter.unitOptions = .temperatureWithoutUnit
                DispatchQueue.main.async {
                    self.temperatureLabel.text = measurementFormatter.string(from: measurement)
                }
                DispatchQueue.main.async {
                    self.humidityLabel.text = String(weatherData.humidity)
                }
            }
        }
    }
}
//
//            print("DEBUG: weather name is \(weatherData?.name ?? "")")
//            let icon = weatherData?.weather.first?.icon
//            let iconString = URL(string: icon!)
//
//        }
//    }
//}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            let alert = UIAlertController(title: "Location Permission Needed", message: "We need permission to use your location. Please update settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
           // updateWeather(lat: location.coordinate.latitude, long: location.coordinate.longitude)
            updateWeatherCodable(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }
    }
    
}

