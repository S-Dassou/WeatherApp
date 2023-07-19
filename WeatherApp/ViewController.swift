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
        ApiManager.shared.getWeather(lat: lat, long: long)
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

