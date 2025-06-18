//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by dread on 10.06.2025.
//

import Foundation

struct ForecastModel: Identifiable {
    let id = UUID()
    var dayName: String
    var imageName: String
    var minTotalTemp: Double
    var maxTotalTemp: Double
    var minDayTemp: Double
    var maxDayTemp: Double
    var currentTemp: Double
}
