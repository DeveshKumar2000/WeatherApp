//
//  WeatherAppModel.swift
//  WeatherApp
//
//  Created by Devesh Kumar Singh on 25/03/22.
//

import Foundation
struct WeatherAppResponse: Decodable{
    var data: [WeatherModel]?
    var count: Int?
}
struct WeatherModel: Decodable {
    enum CodingKeys: String, CodingKey{
        case cityName = "city_name"
        case temperature = "temp"
        case dateTime = "ob_time"
        case weather
    }
    var cityName: String?
    var temperature: Float?
    var dateTime: String?
    var weather: WeatherInfo?
}
struct WeatherInfo: Decodable {
    var icon: String?
    var description: String?
}

struct CityInfo: Decodable {
    var city: String?
    var lng: Float64?
    var lat: Float64?
}
