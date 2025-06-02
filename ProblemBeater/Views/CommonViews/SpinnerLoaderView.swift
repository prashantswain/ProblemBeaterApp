//
//  SpinnerLoaderView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

class LoadingState: ObservableObject {
    @Published var isLoading: Bool = false
}

struct SpinnerLoaderView: View {
    @Binding var isAnimating: Bool
    @State private var rotation = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.7))
                .frame(width: 150, height: 150)
            Circle()
                .stroke(AngularGradient(gradient: Gradient(colors: [appColor1, appColor2.opacity(0.7), appColor3.opacity(0.3)]), center: .center), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: 75, height: 75)
                .rotationEffect(.degrees(rotation ? 360 : 0))
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: false)) {
                self.rotation.toggle()
            }
        }
        .opacity(isAnimating ? 1 : 0)
//        .onAppear {
//            startRotation()
//        }
//        .onChange(of: isAnimating) { _ in
//            startRotation()
//        }
    }
}

#Preview {
    SpinnerLoaderView(isAnimating: .constant(true))
}
