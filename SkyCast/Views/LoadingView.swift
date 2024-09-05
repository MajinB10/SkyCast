import SwiftUI
import Lottie

struct LoadingView: View {
    private var animationView: LottieAnimationView?
    
    init() {
        animationView = LottieAnimationView(name: "Loading_Lottie") // Replace "Loading" with your JSON file name
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

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
