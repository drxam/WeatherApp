//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by dread on 08.06.2025.
//

import SwiftUI
import SwiftData

@main
struct WeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            WeatherCity.self,
            CurrentWeather.self,
            HourlyWeather.self,
            DailyWeather.self
        ])
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        CitySelectionScreenView(modelContext: modelContext)
    }
}
