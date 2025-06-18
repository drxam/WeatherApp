//
//  CitySearchViewModel.swift
//  WeatherApp
//
//  Created by dread on 17.06.2025.
//

import Foundation

@MainActor
class CitySearchViewModel: ObservableObject {
    @Published var searchResults: [CitySearchResult]
    @Published var isLoading = false
    
    let onCitySelected: (CitySearchResult) -> Void
    
    init(searchResults: [CitySearchResult], onCitySelected: @escaping (CitySearchResult) -> Void) {
        self.searchResults = searchResults
        self.onCitySelected = onCitySelected
    }
    
    func selectCity(_ city: CitySearchResult) {
        onCitySelected(city)
    }
}
