//
//  CustomTabBarView.swift
//  WeatherApp
//
//  Created by dread on 15.06.2025.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedIndex: Int
    @Binding var showCitySelection: Bool
    let locationsCount: Int
    let onRefresh: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .frame(height: 100)
                .offset(y: 50)
            
            HStack {
                Button {
                    onRefresh()
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise.rotate.90")
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                HStack(spacing: 6) {
                    ForEach(0..<locationsCount, id: \.self) { index in
                        Circle()
                            .fill(selectedIndex == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: selectedIndex == index ? 8 : 6, height: selectedIndex == index ? 8 : 6)
                            .scaleEffect(selectedIndex == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: selectedIndex)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedIndex = index
                                }
                            }
                    }
                }
                
                Spacer()
                
                Button {
                    showCitySelection.toggle()
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 20))
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .offset(y: 32)
        }
    }
}
