//
//  LoadingView.swift
//  SkyCast
//
//  Created by Bhavesh Anand on 28/8/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    } 
}

#Preview {
    LoadingView()
}
