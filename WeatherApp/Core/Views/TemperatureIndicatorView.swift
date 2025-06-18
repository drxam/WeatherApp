//
//  TemperatureIndicatorView.swift
//  WeatherApp
//
//  Created by dread on 09.06.2025.
//

import SwiftUI

struct TemperatureIndicatorView: View {
    var model: ForecastModel
    var isFirstCell: Bool
    let height: CGFloat = 5
    
    @State var totalWidth: CGFloat = .zero
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight: height)
                .clipShape(Capsule())
                .foregroundStyle(.gray)
                .opacity(0.5)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                totalWidth = geometry.size.width
                            }
                    }
                )
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: calculateGradientWidth(), height: height)
                    .clipShape(Capsule())
                    .foregroundStyle(
                        LinearGradient(
                            colors: getGradientColors(),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: calculateGradientOffset())
                
                if isFirstCell {
                    Group {
                        Circle()
                            .padding(-3)
                            .foregroundStyle(.black)
                            .blendMode(.destinationOut)
                            .frame(width: height, height: height)
                        
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: height, height: height)
                    }
                    .offset(x: calculateGradientOffset() + calculatePointOffset() - height / 2)
                }
            }
            .compositingGroup()
        }
    }
    
    private func getGradientColors() -> [Color] {
        let thresholds: [(temp: Double, color: Color)] = [
            (-30, Color("coldBlue")),
            (-15, .blue),
            (0, .cyan),
            (15, .green),
            (20, .yellow),
            (25, .orange),
            (35, .red),
            (50, Color("hotRed"))
        ]
        
        func interpolatedColor(for temp: Double) -> Color {
            for i in 0..<(thresholds.count - 1) {
                let (t0, c0) = thresholds[i]
                let (t1, c1) = thresholds[i + 1]
                
                if temp >= t0 && temp <= t1 {
                    let ratio = CGFloat(temp - t0) / CGFloat(t1 - t0)
                    return c0.mix(with: c1, by: ratio)
                }
            }
            return .green
        }
        
        let startColor = interpolatedColor(for: model.minDayTemp)
        let endColor = interpolatedColor(for: model.maxDayTemp)
        
        return [startColor, endColor]
    }
    
    private func calculatePointOffset() -> CGFloat {
        CGFloat(model.currentTemp - model.minDayTemp) / CGFloat(model.maxDayTemp - model.minDayTemp) * calculateGradientWidth()
    }
    
    private func calculateGradientOffset() -> CGFloat {
        CGFloat(model.minDayTemp - model.minTotalTemp) / CGFloat(model.maxTotalTemp - model.minTotalTemp) * totalWidth
    }
    
    private func calculateGradientWidth() -> CGFloat {
        CGFloat(model.maxDayTemp - model.minDayTemp) / CGFloat(model.maxTotalTemp - model.minTotalTemp) * totalWidth
    }
}
