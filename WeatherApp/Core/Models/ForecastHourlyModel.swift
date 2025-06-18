//
//  ForecastHourlyModel.swift
//  WeatherApp
//
//  Created by dread on 10.06.2025.
//

import Foundation

struct ForecastHourlyModel: Identifiable {
    let id = UUID()
    var title: String
    var imageName: String
    var temperature: Int
}
