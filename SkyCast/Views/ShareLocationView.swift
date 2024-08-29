//
//  ShareLocationView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 29/8/24.
//

import SwiftUI
import CoreLocationUI

struct ShareLocationView: View {
    @ObservedObject var locationmanager: LocationManager
    
    var body: some View {
        VStack {
            Text("Current Location Weather")
                .bold().font(.title)
                .padding()
            
            LocationButton(.shareCurrentLocation) {
                locationmanager.requestLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ShareLocationView(locationmanager: LocationManager())
}
