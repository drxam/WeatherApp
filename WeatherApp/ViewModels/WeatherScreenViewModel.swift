//
//  WeatherScreenViewModel.swift
//  WeatherApp
//
//  Created by dread on 17.06.2025.
//

import Foundation

@MainActor
class WeatherScreenViewModel: ObservableObject {
    @Published var titleModel: TitleModel
    @Published var hourlyForecast: [ForecastHourlyModel] = []
    @Published var dailyForecast: [ForecastModel] = []
    
    private let weatherCity: WeatherCity
    
    init(weatherCity: WeatherCity) {
        self.weatherCity = weatherCity
        self.titleModel = weatherCity.toTitleModel()
        updateForecastData()
    }
    
    func refreshData() {
        titleModel = weatherCity.toTitleModel()
        updateForecastData()
    }
    
    var backgroundImageName: String {
        guard let firstHourlyForecast = hourlyForecast.first else {
            return "clear"
        }
        
        switch firstHourlyForecast.imageName {
        case "sun.max.fill":
            return "clear"
        case "cloud.fill":
            return "clouds_1"
        case "cloud.rain.fill":
            return "rain"
        default:
            return "clear"
        }
    }
    
    private func updateForecastData() {
        hourlyForecast = weatherCity.hourlyForecast
            .sorted { $0.sortOrder < $1.sortOrder }
            .map { $0.toForecastHourlyModel() }
        
        dailyForecast = weatherCity.dailyForecast
            .sorted { $0.sortOrder < $1.sortOrder }
            .map { $0.toForecastModel() }
    }
}
