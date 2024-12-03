import SwiftUI
import Lottie

struct LoadingView: View {
    private var animationView: LottieAnimationView?
    
    init() {
        animationView = LottieAnimationView(name: "Loading_Lottie") // Replace "Loading_Lottie" with your JSON file name
        animationView?.loopMode = .loop
        animationView?.play()
    }
    
    var body: some View {
        ZStack {
            // Black background
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            // Ensure the animation view is added
            LottieView(animationView: animationView)
            
            // Full screen view to block all interactions
            BlockingOverlayView()
                .edgesIgnoringSafeArea(.all) // Ensure it covers the whole screen
        }
    }
}

struct LottieView: UIViewRepresentable {
    var animationView: LottieAnimationView?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        animationView?.frame = view.bounds
        animationView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(animationView!)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct BlockingOverlayView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear // Or UIColor.black.withAlphaComponent(0.5) for a semi-transparent overlay
        view.isUserInteractionEnabled = true // Ensures it blocks interactions
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
