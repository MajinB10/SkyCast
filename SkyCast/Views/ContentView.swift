//
//  ContentView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 28/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationmanager = LocationManager()
    var body: some View {
        VStack {
            
            if let location = locationmanager.location {
                Text("Your coordinates are: \(location.longitude), \(location.latitude)")
            } else {
                if locationmanager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationmanager)
                }
            }
            
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
