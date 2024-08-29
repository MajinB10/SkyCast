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
            
            SearchLocationView(locationManager: locationmanager)
                .tabItem {
                    Label("Search Location", systemImage: "location.circle")
                }
        }
        .background(Color.black) // Ensure the background color is applied
        .preferredColorScheme(.dark)
        .tabViewStyle(.page) // Ensures page view style
    }
}

#Preview {
    ContentView()
}
