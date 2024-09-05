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
    @State private var lastDragValue: CGFloat = UIScreen.main.bounds.height * 0.37
    private let expandedOffset: CGFloat = -9 // Fully expanded size
    private let collapsedOffset: CGFloat = UIScreen.main.bounds.height * 0.37 // Partially visible size
    private let horizontalDragThreshold: CGFloat = 10 // Maximum horizontal movement allowed

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    if isWeatherInfoVisible {
                        Text(weather.name)
                            .bold()
                            .font(.system(size: 28, weight: .medium, design: .monospaced))
                            .transition(.slide)

                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .transition(.opacity)
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
                                    .transition(.scale)

                                Text(weather.weather[0].main)
                                    .transition(.opacity)
                                    .font(.system(size: 15, weight: .medium, design: .monospaced))
                            }
                            .frame(maxWidth: 150, alignment: .leading)

                            Spacer()
                            Text(weather.main.feelsLike.roundDouble() + "°")
                                .font(.system(size: 90, weight: .medium, design: .monospaced))
                                .fontWeight(.bold)
                                .padding()
                                .transition(.opacity)
                        }

                        Spacer().frame(height: 0)

                        if let imageName = selectedImageName {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                                .cornerRadius(20, corners: .allCorners)
                                .transition(.opacity)
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
                            .transition(.opacity)

                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + "°"))
                                .transition(.slide)
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                                .transition(.slide)
                        }
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind Speed", value: (weather.wind.speed.roundDouble() + "m/s"))
                                .transition(.slide)
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                                .transition(.slide)
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
                                // Update the drag offset based on vertical motion
                                if abs(value.translation.width) < horizontalDragThreshold {
                                    let newOffset = lastDragValue + value.translation.height
                                    dragOffset = min(max(newOffset, expandedOffset), collapsedOffset)
                                }
                            }
                            .onEnded { value in
                                let velocity = value.predictedEndTranslation.height
                                
                                withAnimation(
                                    Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2)
                                        .speed(1.2) // Faster animation speed
                                ) {
                                    if abs(velocity) > 500 {
                                        // Flick gesture detected
                                        if velocity < 0 {
                                            dragOffset = expandedOffset // Fully expanded
                                        } else {
                                            dragOffset = collapsedOffset // Partially visible
                                        }
                                    } else {
                                        // Regular drag
                                        if dragOffset < (collapsedOffset + expandedOffset) / 2 {
                                            dragOffset = expandedOffset // Fully expanded
                                        } else {
                                            dragOffset = collapsedOffset // Partially visible
                                        }
                                    }
                                }
                                lastDragValue = dragOffset
                            }
                    )
                    .contentShape(Rectangle()) // Ensure the entire view area is interactive
                    .transition(.move(edge: .bottom))
                    .font(.system(size: 28, weight: .medium, design: .monospaced))
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Update the drag offset only if vertical motion is detected
                    if abs(value.translation.width) < horizontalDragThreshold {
                        let newOffset = lastDragValue + value.translation.height
                        dragOffset = min(max(newOffset, expandedOffset), collapsedOffset)
                    }
                }
                .onEnded { value in
                    // Decide whether to fully expand or collapse based on the final drag position
                    let velocity = value.predictedEndTranslation.height
                    
                    withAnimation(
                        Animation.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.2)
                            .speed(1.2) // Faster animation speed
                    ) {
                        if abs(velocity) > 500 {
                            if velocity < 0 {
                                dragOffset = expandedOffset // Fully expanded
                            } else {
                                dragOffset = collapsedOffset // Partially visible
                            }
                        } else {
                            if dragOffset < (collapsedOffset + expandedOffset) / 2 {
                                dragOffset = expandedOffset // Fully expanded
                            } else {
                                dragOffset = collapsedOffset // Partially visible
                            }
                        }
                    }
                    lastDragValue = dragOffset
                }
        )
        .edgesIgnoringSafeArea(.bottom)
        .background(.black)
        .preferredColorScheme(.dark)
        .onAppear {
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
