//
//  CitySelectionModel.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import Foundation

struct CitySelectionModel: Identifiable {
    let id = UUID()
    var cityName: String
    var weatherDescription: String
    var temp: Int
    var maxTemp: Int
    var minTemp: Int
}
