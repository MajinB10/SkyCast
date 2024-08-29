//
//  ContentView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 28/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationmanager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        TabView {
            HomeView(locationmanager: locationmanager, weatherManager: weatherManager, weather: $weather)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            ShareLocationView(locationmanager: locationmanager)
                .tabItem {
                    Label("Share Location", systemImage: "location.circle")
                }
                
        }
        .background(.black)
        .preferredColorScheme(.dark)
        .tabViewStyle(.page)
    }
}

#Preview {
    ContentView()
}
