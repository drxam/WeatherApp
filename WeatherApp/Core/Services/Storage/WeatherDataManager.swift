//
//  WeatherDataManager.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import Foundation
import SwiftData

@MainActor
class WeatherDataManager: ObservableObject {
    var modelContext: ModelContext
    private let apiService: WeatherAPIService
    
    @Published var cities: [WeatherCity] = []
    @Published var selectedCity: WeatherCity?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    init(modelContext: ModelContext, apiService: WeatherAPIService = WeatherAPIService()) {
        self.modelContext = modelContext
        self.apiService = apiService
        loadCities()
    }
    
    // MARK: - Public Methods
        
    func addCity(from searchResult: CitySearchResult) async {
        guard !cities.contains(where: { $0.cityName == searchResult.localizedName }) else {
            errorMessage = "Город уже добавлен"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let (currentWeather, hourlyForecast, dailyForecast) = try await apiService.fetchWeatherData(for: searchResult.key)
            
            let weatherCity = createWeatherCity(
                from: searchResult,
                currentWeather: currentWeather,
                hourlyForecast: hourlyForecast,
                dailyForecast: dailyForecast
            )
            
            saveWeatherCity(weatherCity)
            loadCities()
            
        } catch {
            handleError(error, message: "Ошибка загрузки данных")
        }
        
        isLoading = false
    }
    
    func removeCity(_ city: WeatherCity) {
        modelContext.delete(city)
        saveContext()
        loadCities()
    }
    
    func selectCity(_ city: WeatherCity) {
        selectedCity?.isSelected = false
        
        city.isSelected = true
        selectedCity = city
        
        saveContext()
    }
    
    func refreshWeatherData() async {
        guard let city = selectedCity else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let (currentWeather, hourlyForecast, dailyForecast) = try await apiService.fetchWeatherData(for: city.cityKey)
            
            updateWeatherCity(
                city,
                currentWeather: currentWeather,
                hourlyForecast: hourlyForecast,
                dailyForecast: dailyForecast
            )
            
            city.lastUpdated = Date()
            saveContext()
            loadCities()
            
        } catch {
            handleError(error, message: "Ошибка обновления данных")
        }
        
        isLoading = false
    }
    
    // MARK: - Private Methods
    
    private func loadCities() {
        let request = FetchDescriptor<WeatherCity>(
            sortBy: [SortDescriptor(\.cityName)]
        )
        
        do {
            cities = try modelContext.fetch(request)
            
            for city in cities {
                city.hourlyForecast.sort { $0.sortOrder < $1.sortOrder }
                city.dailyForecast.sort { $0.sortOrder < $1.sortOrder }
            }
            
            selectedCity = cities.first { $0.isSelected }
        } catch {
            handleError(error, message: "Ошибка загрузки городов")
        }
    }
    
    private func createWeatherCity(
        from searchResult: CitySearchResult,
        currentWeather: CurrentWeather,
        hourlyForecast: [HourlyWeather],
        dailyForecast: [DailyWeather]
    ) -> WeatherCity {
        let weatherCity = WeatherCity(cityName: searchResult.localizedName, cityKey: searchResult.key)
        
        let current = CurrentWeather(
            temperature: currentWeather.temperature,
            description: currentWeather.desc,
            maxTemp: currentWeather.maxTemp,
            minTemp: currentWeather.minTemp,
            imageName: currentWeather.imageName
        )
        current.city = weatherCity
        weatherCity.currentWeather = current
        
        let hourlyWeathers = createHourlyWeathers(from: hourlyForecast, for: weatherCity)
        weatherCity.hourlyForecast = hourlyWeathers
        
        let dailyWeathers = createDailyWeathers(from: dailyForecast, for: weatherCity, currentTemp: Double(current.temperature))
        weatherCity.dailyForecast = dailyWeathers
        
        calculateAndSetTotalTemperatures(for: weatherCity)
        
        return weatherCity
    }
    
    private func createHourlyWeathers(from forecast: [HourlyWeather], for city: WeatherCity) -> [HourlyWeather] {
        return forecast.enumerated().map { index, hourly in
            let hw = HourlyWeather(
                time: hourly.time,
                temperature: hourly.temperature,
                imageName: hourly.imageName,
                sortOrder: index
            )
            hw.city = city
            return hw
        }
    }
    
    private func createDailyWeathers(from forecast: [DailyWeather], for city: WeatherCity, currentTemp: Double) -> [DailyWeather] {
        return forecast.enumerated().map { index, daily in
            let dw = DailyWeather(
                dayName: daily.dayName,
                imageName: daily.imageName,
                minTemp: daily.minTemp,
                maxTemp: daily.maxTemp,
                currentTemp: currentTemp,
                sortOrder: index
            )
            dw.city = city
            return dw
        }
    }
    
    private func updateWeatherCity(
        _ city: WeatherCity,
        currentWeather: CurrentWeather,
        hourlyForecast: [HourlyWeather],
        dailyForecast: [DailyWeather]
    ) {
        if let current = city.currentWeather {
            current.temperature = currentWeather.temperature
            current.desc = currentWeather.desc
            current.maxTemp = currentWeather.maxTemp
            current.minTemp = currentWeather.minTemp
            current.imageName = currentWeather.imageName
        }
        
        city.hourlyForecast.forEach { modelContext.delete($0) }
        city.dailyForecast.forEach { modelContext.delete($0) }
        
        let newHourlyWeathers = createHourlyWeathers(from: hourlyForecast, for: city)
        let newDailyWeathers = createDailyWeathers(from: dailyForecast, for: city, currentTemp: Double(city.currentWeather?.temperature ?? 0))
        
        city.hourlyForecast = newHourlyWeathers
        city.dailyForecast = newDailyWeathers
        
        newHourlyWeathers.forEach { modelContext.insert($0) }
        newDailyWeathers.forEach { modelContext.insert($0) }
        
        calculateAndSetTotalTemperatures(for: city)
    }
    
    private func saveWeatherCity(_ weatherCity: WeatherCity) {
        modelContext.insert(weatherCity)
        
        if let current = weatherCity.currentWeather {
            modelContext.insert(current)
        }
        
        weatherCity.hourlyForecast.forEach { modelContext.insert($0) }
        weatherCity.dailyForecast.forEach { modelContext.insert($0) }
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            handleError(error, message: "Ошибка сохранения данных")
        }
    }
    
    private func handleError(_ error: Error, message: String) {
        errorMessage = "\(message): \(error.localizedDescription)"
        print("WeatherDataManager Error: \(error)")
    }
    
    private func calculateAndSetTotalTemperatures(for city: WeatherCity) {
        guard !city.dailyForecast.isEmpty else { return }
        
        let minTotalTemp = city.dailyForecast.min(by: { $0.minTemp < $1.minTemp })?.minTemp ?? 0.0
        let maxTotalTemp = city.dailyForecast.max(by: { $0.maxTemp < $1.maxTemp })?.maxTemp ?? 0.0
        
        let firstDay = city.dailyForecast.first
        let minCurrentTemp = firstDay?.minTemp ?? 0
        let maxCurrentTemp = firstDay?.maxTemp ?? 0
        
        for dailyWeather in city.dailyForecast {
            dailyWeather.minTotalTemp = Int(minTotalTemp)
            dailyWeather.maxTotalTemp = Int(maxTotalTemp)
        }
        
        if let currentWeather = city.currentWeather {
            currentWeather.minTemp = Int(minCurrentTemp)
            currentWeather.maxTemp = Int(maxCurrentTemp)
        }
    }
}
