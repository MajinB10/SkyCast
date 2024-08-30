import SwiftUI

struct HomeView: View {
    @ObservedObject var locationmanager: LocationManager
    var weatherManager: WeatherManager
    @Binding var weather: ResponseBody?
    @State private var showWeatherView = false
    @State private var showLoadingView = false
    var onBack: () -> Void  // Callback to notify parent when going back

    var body: some View {
        NavigationStack {
            VStack {
                if showWeatherView, let weather = weather {
                    WeatherView(weather: weather)
                        .transition(.slide)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("  < Back") {
                                    // Notify parent to reset weather and go back
                                    withAnimation {
                                        onBack()
                                        showWeatherView = false
                                        showLoadingView = false
                                    }
                                }
                            }
                        }
                } else {
                    if let location = locationmanager.location {
                        if showLoadingView {
                            LoadingView()
                                .transition(.opacity)
                                .task {
                                    do {
                                        weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                        withAnimation {
                                            showWeatherView = true
                                        }
                                    } catch {
                                        print("Error getting weather: \(error)")
                                    }
                                    showLoadingView = false
                                }
                        } else {
                            WelcomeView()
                                .transition(.move(edge: .bottom))
                                .environmentObject(locationmanager)
                        }
                    } else {
                        if locationmanager.isLoading {
                            LoadingView()
                                .transition(.opacity)
                        } else {
                            WelcomeView()
                                .transition(.move(edge: .bottom))
                                .environmentObject(locationmanager)
                        }
                    }
                }
            }
            .background(.black)
            .preferredColorScheme(.dark)
            .onAppear {
                // Ensure loading view is shown when appropriate
                if !showWeatherView && !showLoadingView {
                    withAnimation {
                        showLoadingView = true
                    }
                }
            }
        }
    }
}


// ParentView to manage state and pass callback to HomeView
struct ParentView: View {
    @State private var weather: ResponseBody?

    var body: some View {
        HomeView(
            locationmanager: LocationManager(),
            weatherManager: WeatherManager(),
            weather: $weather,
            onBack: {
                // Handle resetting weather here
                withAnimation {
                    weather = nil
                }
            }
        )
    }
}

// Preview provider
#Preview {
    ParentView()
}
