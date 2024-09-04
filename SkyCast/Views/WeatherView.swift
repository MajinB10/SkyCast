import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    let imageNames = [
        "Scenery_1",
        "Scenery_2",
        "Scenery_3",
        "Scenery_4",
        "Scenery_5",
        "Scenery_6",
        "Scenery_7",
        "Scenery_8"
    ]

    @State private var isWeatherInfoVisible = false
    @State private var isWeatherDetailsVisible = false
    @State private var selectedImageName: String? = nil
    @State private var dragOffset: CGFloat = UIScreen.main.bounds.height * 0.37 // Partially visible
    @State private var lastDragValue: CGFloat = 0
    private let expandedOffset: CGFloat = -9 // Fully expanded size
    private let collapsedOffset: CGFloat = UIScreen.main.bounds.height * 0.37 // Partially visible size

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

                        if let imageName = selectedImageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                                .cornerRadius(20, corners: .allCorners)
                                .transition(.opacity) // Apply the fade-in effect
                                .opacity(isWeatherInfoVisible ? 1 : 0)
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
                        .padding(.bottom, 320)
                    }
                    .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.6, alignment: .leading)
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
                                if dragAmount <= collapsedOffset && dragAmount >= expandedOffset {
                                    dragOffset = dragAmount
                                }
                            }
                            .onEnded { _ in
                                withAnimation {
                                    if dragOffset < (collapsedOffset + expandedOffset) / 2 {
                                        dragOffset = expandedOffset // Fully expanded
                                    } else {
                                        dragOffset = collapsedOffset // Partially visible
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
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Prevent horizontal drag gestures
                    if abs(value.translation.width) > abs(value.translation.height) {
                        // Ignored horizontal drag
                    }
                }
                .onEnded { _ in
                    // Prevent horizontal drag gestures
                }
        )
        .onAppear {
            // Select a random image once when the view appears
            selectedImageName = imageNames.randomElement() ?? imageNames[0]

            withAnimation(.easeInOut(duration: 1.0)) {
                isWeatherInfoVisible = true
            }
            withAnimation(.easeInOut(duration: 1.5)) {
                isWeatherDetailsVisible = true
            }
        }
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
