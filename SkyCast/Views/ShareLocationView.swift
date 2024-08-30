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
    
    let countries = [
        "Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia",
        "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin",
        "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi",
        "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia",
        "Comoros", "Congo, Democratic Republic of the", "Congo, Republic of the", "Costa Rica", "Croatia", "Cuba",
        "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador",
        "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Fiji", "Finland",
        "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea",
        "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq",
        "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Korea, North",
        "Korea, South", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia",
        "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives",
        "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco",
        "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands",
        "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Macedonia", "Norway", "Oman", "Pakistan", "Palau",
        "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania",
        "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa",
        "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone",
        "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Sudan", "Spain",
        "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania",
        "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan",
        "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay",
        "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"
    ]

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
