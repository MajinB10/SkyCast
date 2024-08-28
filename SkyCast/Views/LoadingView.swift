//
//  LoadingView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 28/8/24.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false

    var body: some View {
        /*ProgressView("Fetching Weather Data...")
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)*/
        
        ZStack {

                    Text("Fetching Current Weather Data...")
                        .font(.system(.body, design: .rounded))
                        .bold()
                        .offset(x: 0, y: -25)

                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color(.systemGray5), lineWidth: 3)
                        .frame(width: 250, height: 3)

                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.green, lineWidth: 3)
                        .frame(width: 30, height: 3)
                        .offset(x: isLoading ? 110 : -110, y: 0)
                        .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                }
                .onAppear() {
                    self.isLoading = true
                }
    }
}

#Preview {
    LoadingView()
}
