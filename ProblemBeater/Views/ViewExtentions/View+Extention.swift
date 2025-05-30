//
//  View+Extention.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

extension View {
    func spinnerOverlay(isLoading: Bool) -> some View {
            ZStack {
                self
                if isLoading {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    SpinnerLoaderView(isAnimating: .constant(true))
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut, value: isLoading)
            .allowsHitTesting(!isLoading) // Disable interaction underneath
        }
}
