//
//  HomeView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 29/8/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var locationmanager: LocationManager
    var weatherManager: WeatherManager
    @Binding var weather: ResponseBody?
    
    var body: some View {
        VStack {
            if let location = locationmanager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
            } else {
                if locationmanager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationmanager)
                }
            }
        }
        .background(.black)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    HomeView(locationmanager: LocationManager(), weatherManager: WeatherManager(), weather: .constant(nil))
}
