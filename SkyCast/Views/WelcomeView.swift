import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var isImageVisible = false
    @State private var isTextVisible = false
    @State private var isImageLoaded = false

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Spacer()
                    .frame(height: 0)

                // Animate the appearance of the image
                if isImageVisible {
                    AsyncImage(url: URL(string: "https://i.pinimg.com/550x/91/92/88/919288e85eb8442e0b4e7e9bb774e803.jpg")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                            .cornerRadius(30, corners: .allCorners)
                            .opacity(isImageLoaded ? 1 : 0) // Fade in effect for the image
                            .scaleEffect(isImageLoaded ? 1 : 0.8) // Scale in effect for the image
                            .onAppear {
                                withAnimation(.easeIn(duration: 1.0)) {
                                    isImageLoaded = true
                                }
                            }
                    } placeholder: {
                        ProgressView()
                    }
                }

                // Animate the appearance of the text
                if isTextVisible {
                    Text("Welcome to the Weather App")
                        .bold().font(.title)
                        .transition(.opacity) // Fade-in transition for the title text

                    Text("Please share your current location to get the weather in your area")
                        .padding()
                        .transition(.opacity) // Fade-in transition for the description text
                }
            }
            .multilineTextAlignment(.center)
            .padding()

            // Location Button with no transition as it is always visible
            LocationButton(.shareCurrentLocation) {
                locationManager.requestLocation()
                print("Location request triggered")
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            // Trigger the animations with a delay to make the transition smoother
            withAnimation(.easeIn(duration: 1.0)) {
                isImageVisible = true
            }
            withAnimation(.easeIn(duration: 1.5)) {
                isTextVisible = true
            }
        }
    }
}

#Preview {
    WelcomeView().environmentObject(LocationManager())
}
