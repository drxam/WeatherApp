//
//  CitySearchView.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import SwiftUI

struct CitySearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var searchResults: [CitySearchResult]
    let onCitySelected: (CitySearchResult) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    if searchResults.isEmpty {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Города не найдены")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(searchResults, id: \.key) { city in
                                Button {
                                    onCitySelected(city)
                                    dismiss()
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("\(city.localizedName), \(city.country.localizedName)")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(.white)
                                            
                                            Text("Key: \(city.key)")
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14))
                                    }
                                    .padding(.vertical, 8)
                                }
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Результаты поиска")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}
