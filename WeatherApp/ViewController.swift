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
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(ApiManager.shared.apiKey)&units=metric") else {
            print("DEBUG: url session error")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: Error fetching results \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("DEBUG: Error getting data ")
                return
            }
            do {
                if let weatherData = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let locationName = weatherData["name"] as? String {
                        DispatchQueue.main.async {
                            self.locationLabel.text = locationName
                        }
                    }
                    
                    if let weatherArray = weatherData["weather"] as? [[String: Any]] {
                        let weather = weatherArray[0]
                        if let description = weather["description"] as? String {
                            DispatchQueue.main.async {
                                self.weatherDescriptionLabel.text = description
                            }
                        }
                        if let icon = weather["icon"] as? String {
                            let iconString = "https://openweathermap.org/img/wn/" + icon + ".png"
                            let iconURL = URL(string: iconString)
                            self.weatherImageView.sd_setImage(with: iconURL, placeholderImage: UIImage(systemName: "person.fill"))
                        }
                    }
                    if let mainData = weatherData["main"] as? [String: Any] {
                        if let temperature = mainData["temp"] as? Double {
                            let measurement = Measurement(value: temperature, unit: UnitTemperature.celsius)
                            let measurementFormatter = MeasurementFormatter()
                            measurementFormatter.unitStyle = .short
                            measurementFormatter.numberFormatter.maximumFractionDigits = 0
                            measurementFormatter.unitOptions = .temperatureWithoutUnit
                            
                            DispatchQueue.main.async {
                                self.temperatureLabel.text = measurementFormatter.string(from: measurement)
                            }
                        }
                        if let humidity = mainData["humidity"] as? Double {
                            DispatchQueue.main.async {
                                self.humidityLabel.text = String(humidity)
                            }
                        }
                    }
                    
                    print(weatherData)
                } else {
                    print("DEBUG: could not convert to dictionary")
                }
                
            }
            catch {
                print("Could not convert JSON data")
            }
        }
        .resume()
    }
}


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
            updateWeather(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        }
    }
    
}

