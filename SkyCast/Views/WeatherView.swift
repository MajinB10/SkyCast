import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    let imageUrls = [
        "https://wallpapersmug.com/download/1024x768/7a22c5/forest_mountains_sunset_cool_weather_minimalism.jpg",
        "https://images.hdqwalls.com/download/firewatch-minimal-jx-1024x768.jpg",
        "https://images.hdqwalls.com/download/minimal-landscape-8k-o2-1024x768.jpg",
        "https://images.hdqwalls.com/download/minimal-landscape-8k-o2-1024x768.jpg",
        "https://images.hdqwalls.com/download/penguin-minimal-8k-ni-1024x768.jpg",
        "https://images.hdqwalls.com/download/fox-minimal-artwork-4k-9g-1024x768.jpg",
        "https://images.hdqwalls.com/download/firewatch-game-sunset-wallpaper-1024x768.jpg",
        "https://images.hdqwalls.com/download/firewatch-sun-trees-mountains-birds-lake-evening-x8-1024x768.jpg",
        "https://images.hdqwalls.com/download/firewatch-trees-pic-1024x768.jpg"
    ]

    @State private var isWeatherInfoVisible = false
    @State private var isWeatherDetailsVisible = false
    @State private var isImageLoaded = false
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragValue: CGFloat = 0
    private let expandedOffset: CGFloat = -UIScreen.main.bounds.height * 0.4 // Adjusted size when expanded
    private let collapsedOffset: CGFloat = 0 // Original size

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    if isWeatherInfoVisible {
                        Text(weather.name)
                            .bold()
                            .font(.system(size: 28, weight: .medium, design: .monospaced))
                            .transition(.slide) // Slide in effect for the city name

                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .transition(.opacity) // Fade in effect for the date
                            .font(.system(size: 17, weight: .medium, design: .monospaced))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)

                Spacer()

                VStack {
                    if isWeatherInfoVisible {
                        HStack {
                            VStack(spacing: 20) {
                                Image(systemName: "sun.max")
                                    .font(.system(size: 40))
                                    .transition(.scale) // Scale in effect for the weather icon

                                Text(weather.weather[0].main)
                                    .transition(.opacity) // Fade in effect for the weather condition
                                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                            }
                            .frame(maxWidth: 150, alignment: .leading)

                            Spacer()
                            Text(weather.main.feelsLike.roundDouble() + "°")
                                .font(.system(size: 90, weight: .medium, design: .monospaced))
                                .fontWeight(.bold)
                                .padding()
                                .transition(.opacity) // Fade in effect for the temperature
                        }

                        Spacer().frame(height: 0)

                        let randomUrlString = imageUrls.randomElement() ?? imageUrls[0]
                        if let randomUrl = URL(string: randomUrlString) {
                            AsyncImage(url: randomUrl) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350)
                                    .cornerRadius(20, corners: .allCorners)
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            isImageLoaded = true
                                        }
                                    }
                                    .opacity(isImageLoaded ? 1 : 0) // Apply the fade-in effect
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Text("Image failed to load")
                        }
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)

            VStack {
                Spacer()

                if isWeatherDetailsVisible {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Current Weather Conditions")
                            .bold()
                            .padding(.bottom)
                            .font(.system(size: 16, weight: .medium, design: .monospaced))
                            .transition(.opacity) // Fade in effect for "Weather now"

                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + "°"))
                                .transition(.slide) // Slide in effect for the first row
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                                .transition(.slide) // Slide in effect for the second row
                        }
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind Speed", value: (weather.wind.speed.roundDouble() + "m/s"))
                                .transition(.slide) // Slide in effect for the third row
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                                .transition(.slide) // Slide in effect for the fourth row
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .offset(y: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let dragAmount = value.translation.height + lastDragValue
                                if dragAmount < 0 && dragAmount >= expandedOffset { // Allow dragging up to expanded size
                                    dragOffset = dragAmount
                                }
                            }
                            .onEnded { value in
                                withAnimation {
                                    if dragOffset < expandedOffset / 2 {
                                        dragOffset = expandedOffset // Fully expanded
                                    } else {
                                        dragOffset = collapsedOffset // Return to original size
                                    }
                                }
                                lastDragValue = dragOffset
                            }
                    )
                    .transition(.move(edge: .bottom)) // Move in from bottom for the details section
                    .font(.system(size: 28, weight: .medium, design: .monospaced))
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(.black)
        .preferredColorScheme(.dark)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0)) {
                isWeatherInfoVisible = true
            }
            withAnimation(.easeInOut(duration: 1.5)) {
                isWeatherDetailsVisible = true
            }
        }
        .gesture(
            DragGesture()
                .onChanged { _ in }
                .onEnded { _ in }
        ) // Prevent horizontal swipes by overriding the gesture
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
