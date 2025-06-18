//
//  WeatherScreenView.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import SwiftUI

struct WeatherScreenView: View {
    @StateObject private var viewModel: WeatherScreenViewModel
    
    init(weatherCity: WeatherCity) {
        self._viewModel = StateObject(wrappedValue: WeatherScreenViewModel(weatherCity: weatherCity))
    }
    
    var body: some View {
        ZStack {
            BackgroundImageView(imageName: viewModel.backgroundImageName)
            
            ScrollView(showsIndicators: false) {
                VStack {
                    TitleView(model: viewModel.titleModel)
                        .padding(.top, 30)
                    
                    Spacer(minLength: 70)
                    
                    ForecastTableHourlyView(
                        models: viewModel.hourlyForecast,
                        description: viewModel.titleModel.description
                    )
                    
                    Spacer(minLength: 15)
                    
                    ForecastTable5DaysView(models: viewModel.dailyForecast)
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            viewModel.refreshData()
        }
    }
}
