//
//  CitySelectionView.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import SwiftUI

struct CityCellView: View {
    var model: CitySelectionModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.cityName)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(10)
                    .padding(.leading, 10)
                
                Spacer()
                
                Text(model.weatherDescription)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(10)
                    .padding(.leading, 10)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(model.temp)°")
                    .font(.system(size: 50, weight: .regular))
                    .foregroundStyle(.white)
                    .padding(10)
                
                Spacer()
                
                HStack {
                    Text("Макс:\(model.maxTemp)° Мин:\(model.minTemp)°")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(10)
                }
            }
        }
        
        .background {
            Image("clear")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: 240)
                .clipped(antialiased: true)
        }
        .frame(maxWidth: .infinity, maxHeight: 120)
        .clipShape(.buttonBorder)
    }
}
