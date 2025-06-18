//
//  SwiftDataModels.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import Foundation
import SwiftData

@Model
class WeatherCity {
    @Attribute(.unique) var cityName: String
    var cityKey: String
    var currentWeather: CurrentWeather?
    var hourlyForecast: [HourlyWeather]
    var dailyForecast: [DailyWeather]
    var lastUpdated: Date
    var isSelected: Bool
    
    init(cityName: String, cityKey: String = "", lastUpdated: Date = Date(), isSelected: Bool = false) {
        self.cityName = cityName
        self.cityKey = cityKey
        self.lastUpdated = lastUpdated
        self.isSelected = isSelected
        self.hourlyForecast = []
        self.dailyForecast = []
    }
}

@Model
class CurrentWeather {
    var temperature: Int
    var desc: String
    var maxTemp: Int
    var minTemp: Int
    var imageName: String
    var city: WeatherCity?
    
    init(temperature: Int, description: String, maxTemp: Int, minTemp: Int, imageName: String) {
        self.temperature = temperature
        self.desc = description
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.imageName = imageName
    }
}

@Model
class HourlyWeather {
    var time: String
    var temperature: Int
    var imageName: String
    var sortOrder: Int
    var city: WeatherCity?
    
    init(time: String, temperature: Int, imageName: String, sortOrder: Int = 0) {
        self.time = time
        self.temperature = temperature
        self.imageName = imageName
        self.sortOrder = sortOrder
    }
}

@Model
class DailyWeather {
    var dayName: String
    var imageName: String
    var minTemp: Double
    var maxTemp: Double
    var minTotalTemp: Int
    var maxTotalTemp: Int
    var currentTemp: Double
    var sortOrder: Int
    var city: WeatherCity?
    
    init(dayName: String, imageName: String, minTemp: Double, maxTemp: Double, currentTemp: Double, sortOrder: Int = 0) {
        self.dayName = dayName
        self.imageName = imageName
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.minTotalTemp = 0
        self.maxTotalTemp = 0
        self.currentTemp = currentTemp
        self.sortOrder = sortOrder
    }
}

extension WeatherCity {
    func toCitySelectionModel() -> CitySelectionModel {
        return CitySelectionModel(
            cityName: self.cityName,
            weatherDescription: self.currentWeather?.desc ?? "",
            temp: self.currentWeather?.temperature ?? 0,
            maxTemp: self.currentWeather?.maxTemp ?? 0,
            minTemp: self.currentWeather?.minTemp ?? 0
        )
    }
    
    func toTitleModel() -> TitleModel {
        return TitleModel(
            cityName: self.cityName,
            temperature: self.currentWeather?.temperature ?? 0,
            description: self.currentWeather?.desc ?? "",
            maxTemp: self.currentWeather?.maxTemp ?? 0,
            minTemp: self.currentWeather?.minTemp ?? 0
        )
    }
}

extension HourlyWeather {
    func toForecastHourlyModel() -> ForecastHourlyModel {
        return ForecastHourlyModel(
            title: self.time,
            imageName: self.imageName,
            temperature: self.temperature
        )
    }
}

extension DailyWeather {
    func toForecastModel() -> ForecastModel {
        return ForecastModel(
            dayName: self.dayName,
            imageName: self.imageName,
            minTotalTemp: Double(self.minTotalTemp),
            maxTotalTemp: Double(self.maxTotalTemp),
            minDayTemp: self.minTemp,
            maxDayTemp: self.maxTemp,
            currentTemp: self.currentTemp
        )
    }
}
