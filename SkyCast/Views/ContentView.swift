import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?

    var body: some View {
        TabView {
            HomeView(
                locationmanager: locationManager,
                weatherManager: weatherManager,
                weather: $weather,
                onBack: {
                    weather = nil
                }
            )
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            SearchLocationView(locationManager: locationManager)
                .tabItem {
                    Label("Search Location", systemImage: "location.circle")
                }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .tabViewStyle(.page)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ContentView()
}
