//
//  ContentView.swift
//  WeatherApp
//
//  Created by dread on 08.06.2025.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel: MainScreenViewModel
    @Binding var showCitySelection: Bool
    
    init(weatherDataManager: WeatherDataManager, showCitySelection: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: MainScreenViewModel(weatherDataManager: weatherDataManager))
        self._showCitySelection = showCitySelection
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.selectedPageIndex) {
                ForEach(Array(viewModel.cities.enumerated()), id: \.element.cityName) { index, city in
                    WeatherScreenView(weatherCity: city,
                                      isLoading: $viewModel.isLoading)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea()
            .onChange(of: viewModel.selectedPageIndex) { oldValue, newValue in
                viewModel.selectCity(at: newValue)
            }
            
            VStack {
                Spacer()
                
                CustomTabBarView(
                    selectedIndex: $viewModel.selectedPageIndex,
                    showCitySelection: $showCitySelection,
                    locationsCount: viewModel.cities.count,
                    onRefresh: {
                        Task {
                            await viewModel.refreshWeatherData()
                        }
                    }
                )
            }
        }
    }
}
