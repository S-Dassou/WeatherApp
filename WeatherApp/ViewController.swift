//
//  ViewController.swift
//  WeatherApp
//
//  Created by shafique dassu on 14/07/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=52.6369&lon=-1.1398&appid=\(ApiManager.shared.apiKey)&units=metric") else {
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
                    print(weatherData)
                } else {
                    print("DEBUG: could not convert to dictionary")
                }
            } catch {
                print("Could not convert JSON data")
            }
        }
        .resume()
    }
    
}

