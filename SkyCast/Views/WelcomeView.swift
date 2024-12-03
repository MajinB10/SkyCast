import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var isImageVisible = false
    @State private var isTextVisible = false
    @State private var isImageLoaded = false

    var body: some View {
        VStack {
            // Animate the appearance of the image
            if isImageVisible {
                if let uiImage = UIImage(named: "Luffy") {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .cornerRadius(30)
                        .opacity(isImageLoaded ? 1 : 0) // Fade in effect for the image
                        .scaleEffect(isImageLoaded ? 1 : 0.9) // Scale in effect for the image
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                isImageLoaded = true
                            }
                        }
                } else {
                    ProgressView()
                }
            }

            // Animate the appearance of the text
            if isTextVisible {
                Text("Welcome to the Weather App")
                    .bold()
                    .font(.system(size: 28, weight: .medium, design: .monospaced))
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                    .foregroundColor(.white)

                Text("Please share your current location to get the latest weather information")
                    .padding()
                    .font(.system(size: 18, weight: .medium, design: .default))
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
                    .foregroundColor(.white)
            }

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
        .padding() // Adjust or remove padding as needed
        .background(Color.black) // Optional: Set background color to ensure visibility
        .onAppear {
            // Trigger the animations with a delay to make the transition smoother
            withAnimation(.easeInOut(duration: 1.0)) {
                isImageVisible = true
            }
            // Delay text animation for a smoother sequence
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.5)) {
                    isTextVisible = true
                }
            }
        }
    }
}

#Preview {
    WelcomeView().environmentObject(LocationManager())
}
