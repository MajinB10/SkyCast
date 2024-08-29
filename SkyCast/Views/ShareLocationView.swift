import SwiftUI
import CoreLocation

struct SearchLocationView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var selectedCountry: String = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var errorMessage: String?
    @State private var isLoading: Bool = false
    @State private var weather: ResponseBody? // Your weather data model
    @State private var navigateToWeatherView: Bool = false
    
    let countries = ["United States", "Canada", "United Kingdom", "Germany", "France", "Australia"]
    private let weatherManager = WeatherManager()
    
    var body: some View {
        NavigationStack {
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
            .overlay(isLoading ? LoadingView() : nil)
            .navigationDestination(isPresented: $navigateToWeatherView) {
                WeatherView(weather: weather ?? previewWeather)
            }
        }
    }
    
    private func fetchWeatherData() {
        guard !selectedCountry.isEmpty else {
            errorMessage = "Please select a country."
            return
        }
        
        print("Fetching weather data for \(selectedCountry)...")
        isLoading = true
        
        getCoordinates(for: selectedCountry) { coordinates, error in
            DispatchQueue.main.async { // Ensure UI updates are on the main thread
                if let error = error {
                    errorMessage = error.localizedDescription
                    isLoading = false
                    print("Error getting coordinates: \(error.localizedDescription)")
                    return
                }
                
                guard let coordinates = coordinates else {
                    errorMessage = "No coordinates found."
                    isLoading = false
                    print("No coordinates found for the selected country.")
                    return
                }
                
                latitude = coordinates.latitude
                longitude = coordinates.longitude
                errorMessage = nil
                
                Task {
                    do {
                        let weatherData = try await weatherManager.getCurrentWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                        DispatchQueue.main.async {
                            weather = weatherData
                            navigateToWeatherView = true
                            print("Weather data fetched successfully.")
                        }
                    } catch {
                        DispatchQueue.main.async {
                            errorMessage = error.localizedDescription
                            print("Error fetching weather data: \(error.localizedDescription)")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        isLoading = false
                    }
                }
            }
        }
    }
}

#Preview {
    SearchLocationView(locationManager: LocationManager())
}
