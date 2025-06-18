//
//  CitySelectionScreenView.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import SwiftUI
import SwiftData

struct CitySelectionScreenView: View {
    @StateObject private var viewModel: CitySelectionViewModel
    
    init(modelContext: ModelContext) {
        let weatherManager = WeatherDataManager(modelContext: modelContext)
        self._viewModel = StateObject(wrappedValue: CitySelectionViewModel(weatherDataManager: weatherManager))
    }
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                headerView
                titleView
                searchBar
                cityList
            }
        }
        .fullScreenCover(isPresented: $viewModel.showMainScreen) {
            MainScreenView(
                weatherDataManager: viewModel.weatherDataManager,
                showCitySelection: $viewModel.showMainScreen
            )
        }
        .sheet(isPresented: $viewModel.showSearchScreen) {
            CitySearchView(
                searchResults: $viewModel.searchResults,
                onCitySelected: { city in
                    Task {
                        await viewModel.addCity(from: city)
                    }
                }
            )
        }
        .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
    
    private var headerView: some View {
        HStack {
            Spacer()
            
            Button {
                viewModel.toggleEditMode()
            } label: {
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .symbolRenderingMode(.monochrome)
                    .foregroundStyle(viewModel.isEditMode ? .red : .white)
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 16)
            }
        }
    }
    
    private var titleView: some View {
        HStack {
            Text("Погода")
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.leading, 10)
                .padding(.top, -5)
            
            Spacer()
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
                .padding(.leading, 8)
            
            TextField("", text: $viewModel.searchText)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
                .disabled(viewModel.isEditMode)
                .overlay(
                    Text("Поиск города")
                        .foregroundColor(.gray)
                        .font(.system(size: 18, weight: .semibold))
                        .opacity(viewModel.searchText.isEmpty ? 1 : 0),
                    alignment: .leading
                )
                .onSubmit {
                    viewModel.searchCities()
                }
        }
        .background {
            Rectangle()
                .foregroundColor(.gray.opacity(viewModel.isEditMode ? 0.1 : 0.3))
                .cornerRadius(10)
                .frame(height: 36)
        }
        .padding(.horizontal, 10)
    }
    
    private var cityList: some View {
        List {
            ForEach(viewModel.cities, id: \.cityName) { city in
                HStack {
                    if viewModel.isEditMode {
                        Button {
                            viewModel.removeCity(city)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                        .padding(.trailing, 8)
                    }
                    
                    CityCellView(model: city.toCitySelectionModel())
                        .onTapGesture {
                            viewModel.selectCity(city)
                        }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
                .padding(6)
                .padding(.horizontal, 4)
                .animation(.easeInOut(duration: 0.3), value: viewModel.isEditMode)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
        .padding(.top, 8)
    }
}
