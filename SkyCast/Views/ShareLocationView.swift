import SwiftUI

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
    @State private var weather: ResponseBody?
    @State private var navigationState: NavigationState = .search
    @State private var isImageVisible = false
    @State private var isTextVisible = false
    @State private var isImageLoaded = false

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
                    Spacer()
                        .frame(height: 20)
                    // Animate the appearance of the image
                    if isImageVisible {
                        ZStack {
                            if isImageLoaded {
                                Image("Search_Location")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 225)
                                    .cornerRadius(30)
                                    .opacity(1) // Image is fully visible
                                    .scaleEffect(1) // Image is fully scaled
                            } else {
                                ProgressView()
                                    .onAppear {
                                        withAnimation(.easeIn(duration: 1.0)) {
                                            isImageLoaded = true
                                        }
                                    }
                            }
                        }
                    }
                    
                    // Animate the appearance of the text
                    if isTextVisible {
                        VStack(spacing: 5) {
                            Text("Selected Country's Current Weather")
                                .bold()
                                .font(.system(size: 28, weight: .medium, design: .monospaced))
                                .scaleEffect(isTextVisible ? 1 : 0.8) // Starts at 80% size
                                .opacity(isTextVisible ? 1 : 0)
                                .animation(.easeOut(duration: 0.8), value: isTextVisible)
                                .multilineTextAlignment(.center)

                            Text("Please select a country to get started.")
                                .font(.system(size: 18, weight: .medium, design: .default))
                                .scaleEffect(isTextVisible ? 1 : 0.8)
                                .opacity(isTextVisible ? 1 : 0)
                                .animation(.easeOut(duration: 0.8).delay(0.2), value: isTextVisible)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Picker("Select a country", selection: $selectedCountry) {
                        Text("Select Country").tag("")
                        ForEach(countries, id: \.self) { country in
                            Text(country)
                                .tag(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .background(Color.black)
                    .cornerRadius(10)
                    .accentColor(.white)
                    
                    Spacer()
                        .frame(height: 15)
                    
                    Button(action: fetchWeatherData) {
                        Label(
                            title: {
                                Text("Get Current Weather")
                                    .font(.system(size: 20))
                            },
                            icon: {
                                Image(systemName: "cloud.sun.fill")
                                    .font(.system(size: 20))
                            }
                        )
                        .padding(10)
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
                .transition(.scale)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0), value: navigationState)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.0)) {
                        isImageVisible = true
                    }
                    withAnimation(.easeInOut(duration: 1.0).delay(0.5)) {
                        isTextVisible = true
                    }
                
                }
                
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
                                    isImageVisible = false
                                    isTextVisible = false
                                    isImageLoaded = false
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

        // Fetch the weather data
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
                            // Introduce a delay of at least 5 seconds for the loading view
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation(.easeInOut) {
                                    weather = weatherData
                                    navigationState = .weather
                                }
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
