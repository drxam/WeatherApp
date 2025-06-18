//
//  BackgroundImage.swift
//  WeatherApp
//
//  Created by dread on 08.06.2025.
//

import SwiftUI

struct BackgroundImageView: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .resizable()
            .ignoresSafeArea()
    }
}
