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
    
    func showToasMessage(isShowing: Binding<Bool>, message: String) -> some View {
        ZStack {
            self
            if isShowing.wrappedValue {
                ToastView(message: message)
                    .ignoresSafeArea()
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .move(edge: .top).combined(with: .opacity)
                        )
                    )
                    .zIndex(1)
                    .animation(.easeInOut(duration: 0.3), value: isShowing.wrappedValue)
            }
        }
        
        .onChange(of: isShowing.wrappedValue) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isShowing.wrappedValue = false
                    }
                }
            }
        }
    }
}
