import SwiftUI
import CoreLocation

enum NavigationState {
    case search
    case loading
    case weather
}

struct SearchLocationView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var selectedCountry: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var errorMessage: String?
    @State private var weather: ResponseBody? // Your weather data model
    @State private var navigationState: NavigationState = .search
    
    let countries = ["United States", "Canada", "United Kingdom", "Germany", "France", "Australia"]
    private let weatherManager = WeatherManager()
    
    var body: some View {
        NavigationStack {
            switch navigationState {
            case .search:
                VStack {
                    Text("Search for Weather")
                        .bold().font(.title)
                        .padding()
                    
                    Picker("Select a country", selection: $selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding()
                    
                    Text("Selected Country: \(selectedCountry)")
                        .padding()
                    
                    Button(action: fetchWeatherData) {
                        Text("Get Weather")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    .padding()
                    
                    if let errorMessage = errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black)
                .preferredColorScheme(.dark)
                .transition(.slide)
                .animation(.easeInOut, value: navigationState)
                
            case .loading:
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .preferredColorScheme(.dark)
                    .transition(.opacity)
                    .animation(.easeInOut, value: navigationState)
                
            case .weather:
                WeatherView(weather: weather ?? previewWeather)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("  < Back") {
                                withAnimation(.easeInOut) {
                                    navigationState = .search
                                }
                            }
                        }
                    }
                    .transition(.slide)
                    .animation(.easeInOut, value: navigationState)
            }
        }
    }
    
    private func fetchWeatherData() {
        guard !selectedCountry.isEmpty else {
            errorMessage = "Please select a country."
            return
        }
        
        withAnimation(.easeInOut) {
            navigationState = .loading
        }
        
        getCoordinates(for: selectedCountry) { coordinates, error in
            DispatchQueue.main.async {
                if let error = error {
                    errorMessage = error.localizedDescription
                    withAnimation(.easeInOut) {
                        navigationState = .search
                    }
                    return
                }
                
                guard let coordinates = coordinates else {
                    errorMessage = "No coordinates found."
                    withAnimation(.easeInOut) {
                        navigationState = .search
                    }
                    return
                }
                
                latitude = coordinates.latitude
                longitude = coordinates.longitude
                errorMessage = nil
                
                Task {
                    do {
                        let weatherData = try await weatherManager.getCurrentWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                        DispatchQueue.main.async {
                            withAnimation(.easeInOut) {
                                weather = weatherData
                                navigationState = .weather
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            errorMessage = error.localizedDescription
                            withAnimation(.easeInOut) {
                                navigationState = .search
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SearchLocationView(locationManager: LocationManager())
}
