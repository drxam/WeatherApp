//
//  ForecastTable5DaysView.swift
//  WeatherApp
//
//  Created by dread on 10.06.2025.
//

import SwiftUI

struct ForecastTable5DaysView: View {
    var models: [ForecastModel]
    
    var body: some View {
        LazyVStack(spacing: 0) {
            HStack {
                Label(
                    "ПРОГНОЗ НА 5 ДН",
                    systemImage: "calendar"
                )
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .opacity(0.5)
                .frame(height: 40)
                .padding(.leading, 14)
                
                Spacer()
            }
            
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            ForEach(models.indices, id: \.self) { index in
                ForecastCellView(
                    model: models[index],
                    isFirstCell: index == 0
                )
                    .background(Color.clear)
                    .frame(height: 50)
                
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal, 16)
            }
        }
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .regular))
                .opacity(0.3)
        )
        .cornerRadius(14)
        .padding(.horizontal, 18)
    }
}
