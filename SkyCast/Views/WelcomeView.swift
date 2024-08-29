//
//  WelcomeView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 28/8/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    
    var body: some View {
        VStack{
            VStack (spacing: 20){
                Spacer()
                    .frame(height: 0)
                AsyncImage(url: URL(string: "https://i.pinimg.com/550x/91/92/88/919288e85eb8442e0b4e7e9bb774e803.jpg")) {image in image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .cornerRadius(30, corners: .allCorners)
                } placeholder: {
                    ProgressView()
                }
                
                
                
                Text("Welcome to the Weather App")
                    .bold().font(.title)
                
                Text("Please share your current location to get the weather in your area")
                    .padding()
                
            }
            .multilineTextAlignment(.center)
            .padding()
            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WelcomeView()
}
