//
//  TitleView.swift
//  WeatherApp
//
//  Created by dread on 08.06.2025.
//

import SwiftUI

struct TitleView: View {
    var model: TitleModel
    
    var body: some View {
        VStack(spacing: -10) {
            Text(model.cityName)
                .font(.system(size: 34, weight: .regular))
                .foregroundStyle(.white)
            
            Text("\(model.temperature)°")
                .font(.system(size: 102, weight: .thin))
                .foregroundStyle(.white)
                .padding(.leading, 28)
            
            Text(model.description)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .padding(.top, 4)
            
            Text("Макс: \(model.maxTemp)°, мин: \(model.minTemp)°")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.white)
                .padding(.top, 10)
        }
    }
}
