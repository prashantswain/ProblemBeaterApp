//
//  SplashScreen.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var showSplash = true
    @State private var scale: CGFloat = 0.3
    var body: some View {
        VStack(alignment: .center) {
            Image("logo")
                .resizable()
                .frame(width: 400, height: 220, alignment: .center)
                .scaledToFit()
                .scaleEffect(scale)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0)) {
                scale = 1.0
            }
        }
    }
}

#Preview {
    SplashScreen()
}
