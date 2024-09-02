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
                VStack {
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 50, height: 50) // Adjust the size here
                    Text("Home")
                }
            }
            
            SearchLocationView(locationManager: locationManager)
                .tabItem {
                    VStack {
                        Image(systemName: "location.circle")
                            .resizable()
                            .frame(width: 24, height: 24) // Adjust the size here
                        Text("Search Location")
                    }
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
