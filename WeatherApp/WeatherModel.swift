
//  Created by shafique dassu on 25/07/2023.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let weather: [WeatherDetail]
    let main: WeatherMain
}

struct WeatherDetail: Decodable {
    let description: String
    let icon: String
}

struct WeatherMain: Decodable {
    let temp: Double
    let humidity: Double
}
