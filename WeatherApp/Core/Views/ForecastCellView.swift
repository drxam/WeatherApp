//
//  ForecastCellView.swift
//  WeatherApp
//
//  Created by dread on 09.06.2025.
//

import SwiftUI

struct ForecastCellView: View {
    var model: ForecastModel
    var isFirstCell: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Text(model.dayName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 76, alignment: .leading)
                .padding(.leading, 16)
            
            Image(systemName: model.imageName)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(width: 60, alignment: .center)
            
            Text("\(Int(model.minDayTemp))°")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 50, alignment: .center)
            
            TemperatureIndicatorView(model: model, isFirstCell: isFirstCell)
                .frame(width: 100, alignment: .center)
            
            Text("\(Int(model.maxDayTemp))°")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 50, alignment: .center)
                .padding(.trailing, 12)
        }
    }
}
