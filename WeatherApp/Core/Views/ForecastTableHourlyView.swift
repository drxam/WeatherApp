//
//  ForecastTableHourlyView.swift
//  WeatherApp
//
//  Created by dread on 10.06.2025.
//

import SwiftUI

struct ForecastTableHourlyView: View {
    var models: [ForecastHourlyModel]
    var description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(.white)
                .padding(.top, 10)
                .padding(.leading, 14)
            
            Divider()
                .background(Color.white.opacity(0.5))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(models.indices, id: \.self) { index in
                        ForecastHourlyView(model: models[index])
                            .frame(width: 60)
                            .padding(.horizontal, 2)
                            .padding(.vertical, 8)
                            .padding(2)
                    }
                }
                .padding(.leading, 6)
            }
        }
        .background(
            VisualEffectView(effect: UIBlurEffect(style: .regular))
                .opacity(0.4)
        )
        .cornerRadius(14)
        .padding(.horizontal, 18)
    }
}
