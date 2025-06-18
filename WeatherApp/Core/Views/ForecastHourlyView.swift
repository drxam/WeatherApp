//
//  ForecastHourlyView.swift
//  WeatherApp
//
//  Created by dread on 10.06.2025.
//

import SwiftUI

struct ForecastHourlyView: View {
    var model: ForecastHourlyModel
    
    var body: some View {
        VStack {
            Text(model.title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
            
            Image(systemName: model.imageName)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            
            Text("\(model.temperature)°")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.top, 2)
                .padding(.leading, 6)
        }
    }
}
