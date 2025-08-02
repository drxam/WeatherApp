//
//  WeatherAPIService.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import Foundation

class WeatherAPIService: ObservableObject {
    private let apiKey: String
        
    init() {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: path),
              let key = plist["API_KEY"] as? String else {
            fatalError("Не удалось загрузить API ключ из Config.plist")
        }
        self.apiKey = key
    }
    
    func searchCities(query: String) async throws -> [CitySearchResult] {
        let urlString = "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(apiKey)&q=\(query)&language=ru-ru"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let searchResults = try JSONDecoder().decode([CitySearchResult].self, from: data)
        
        return searchResults
    }
    
    func fetchWeatherCurrent(for cityKey: String) async throws -> CurrentWeather {
        let urlString = "https://dataservice.accuweather.com/currentconditions/v1/\(cityKey)?apikey=\(apiKey)&language=ru&details=true"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let currentConditions = try JSONDecoder().decode([CurrentWeatherResponse].self, from: data)
        
        guard let condition = currentConditions.first else {
            throw APIError.noData
        }
        
        return CurrentWeather(
            temperature: Int(condition.temperature.metric.value),
            description: condition.weatherText,
            maxTemp: 0,
            minTemp: 0,
            imageName: getImageName(for: condition.weatherIcon)
        )
    }
    
    func fetchWeatherHourly(for cityKey: String) async throws -> [HourlyWeather] {
        let urlString = "https://dataservice.accuweather.com/forecasts/v1/hourly/12hour/\(cityKey)?apikey=\(apiKey)&language=ru&metric=true"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let hourlyForecasts = try JSONDecoder().decode([HourlyWeatherResponse].self, from: data)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H"
        
        return hourlyForecasts.enumerated().map { index, forecast in
            let time = index == 0 ? "Сейчас" : dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(forecast.epochDateTime)))
            
            return HourlyWeather(
                time: time,
                temperature: Int(forecast.temperature.value),
                imageName: getImageName(for: forecast.weatherIcon)
            )
        }
    }
    
    func fetchWeather5Days(for cityKey: String) async throws -> [DailyWeather] {
        let urlString = "https://dataservice.accuweather.com/forecasts/v1/daily/5day/\(cityKey)?apikey=\(apiKey)&language=ru&metric=true"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        
        return weatherResponse.dailyForecasts.enumerated().map { index, forecast in
            let dayName = index == 0 ? "Сегодня" : dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(forecast.epochDate)))
            
            return DailyWeather(
                dayName: dayName,
                imageName: getImageName(for: forecast.icon),
                minTemp: forecast.minTemp,
                maxTemp: forecast.maxTemp,
                currentTemp: 0
            )
        }
    }
    
    func fetchWeatherData(for cityKey: String) async throws -> (CurrentWeather, [HourlyWeather], [DailyWeather]) {
        async let currentWeather = fetchWeatherCurrent(for: cityKey)
        async let hourlyForecast = fetchWeatherHourly(for: cityKey)
        async let dailyForecast = fetchWeather5Days(for: cityKey)
        
        return try await (currentWeather, hourlyForecast, dailyForecast)
    }
    
    // MARK: - Helper Methods
    
    private func getImageName(for iconCode: Int) -> String {
        switch iconCode {
        case 1, 2, 30: return "sun.max.fill"
        case 3, 4, 5, 6: return "cloud.fill"
        case 7, 8, 11: return "cloud.fill"
        case 12, 13, 14, 15, 16, 17, 18: return "cloud.rain.fill"
        case 19, 20, 21, 22, 23, 24, 25, 26, 29: return "cloud.snow.fill"
        case 32, 33, 34, 35: return "sun.max.fill"
        case 36, 37, 38: return "cloud.fill"
        case 39, 40, 41, 42, 43, 44: return "cloud.rain.fill"
        default: return "sun.max.fill"
        }
    }
}

// MARK: - API Response Models

struct CitySearchResult: Codable {
    let localizedName: String
    let country: Country
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case localizedName = "LocalizedName"
        case key = "Key"
        case country = "Country"
    }
    
    struct Country: Codable {
        let localizedName: String
        
        enum CodingKeys: String, CodingKey {
            case localizedName = "LocalizedName"
        }
    }
}

struct WeatherResponse: Decodable {
    let dailyForecasts: [DailyForecast]
    
    enum CodingKeys: String, CodingKey {
        case dailyForecasts = "DailyForecasts"
    }
}

struct DailyForecast: Decodable, Identifiable {
    let id = UUID()
    let minTemp: Double
    let maxTemp: Double
    let icon: Int
    let iconPhrase: String
    let epochDate: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "Temperature"
        case day = "Day"
        case epochDate = "EpochDate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.epochDate = try container.decode(Int.self, forKey: .epochDate)
        
        let tempContainer = try container.nestedContainer(keyedBy: TempKeys.self, forKey: .temperature)
        let minContainer = try tempContainer.nestedContainer(keyedBy: ValueKeys.self, forKey: .minimum)
        let maxContainer = try tempContainer.nestedContainer(keyedBy: ValueKeys.self, forKey: .maximum)
        self.minTemp = try minContainer.decode(Double.self, forKey: .value)
        self.maxTemp = try maxContainer.decode(Double.self, forKey: .value)
        
        let dayContainer = try container.nestedContainer(keyedBy: DayKeys.self, forKey: .day)
        self.icon = try dayContainer.decode(Int.self, forKey: .icon)
        self.iconPhrase = try dayContainer.decode(String.self, forKey: .iconPhrase)
    }
    
    private enum TempKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
    
    private enum ValueKeys: String, CodingKey {
        case value = "Value"
    }
    
    private enum DayKeys: String, CodingKey {
        case icon = "Icon"
        case iconPhrase = "IconPhrase"
    }
}

struct CurrentWeatherResponse: Decodable {
    let weatherText: String
    let weatherIcon: Int
    let temperature: TemperatureInfo
    let temperatureSummary: TemperatureSummary?
    
    enum CodingKeys: String, CodingKey {
        case weatherText = "WeatherText"
        case weatherIcon = "WeatherIcon"
        case temperature = "Temperature"
        case temperatureSummary = "TemperatureSummary"
    }
}

struct TemperatureInfo: Decodable {
    let metric: MetricValue
    
    enum CodingKeys: String, CodingKey {
        case metric = "Metric"
    }
}

struct MetricValue: Decodable {
    let value: Double
    
    enum CodingKeys: String, CodingKey {
        case value = "Value"
    }
}

struct TemperatureSummary: Decodable {
    let past24HourRange: TemperatureRange
    
    enum CodingKeys: String, CodingKey {
        case past24HourRange = "Past24HourRange"
    }
}

struct TemperatureRange: Decodable {
    let minimum: TemperatureInfo
    let maximum: TemperatureInfo
    
    enum CodingKeys: String, CodingKey {
        case minimum = "Minimum"
        case maximum = "Maximum"
    }
}

struct HourlyWeatherResponse: Decodable {
    let epochDateTime: Int
    let weatherIcon: Int
    let temperature: MetricValue
    
    enum CodingKeys: String, CodingKey {
        case epochDateTime = "EpochDateTime"
        case weatherIcon = "WeatherIcon"
        case temperature = "Temperature"
    }
}

// MARK: - Error Types

enum APIError: Error, LocalizedError {
    case noData
    case invalidResponse
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "Нет данных от сервера"
        case .invalidResponse:
            return "Неверный формат ответа"
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        }
    }
}
