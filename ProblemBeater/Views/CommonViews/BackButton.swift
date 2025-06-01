//
//  BackButton.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navManager: NavigationManager
    var onClick: (()->Void)?
    @State var isPressed: Bool = false
    var body: some View {
        Button {
            onClick?()
            if !navManager.path.isEmpty {
//                print(navManager.path.removeLast())
                navManager.path.removeLast()
            }
        } label: {
            Image(systemName: "arrow.left")
                .resizable()
                .frame(width: 35, height: 25)
                .foregroundStyle(.appColor2)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeIn(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
        
    }
}

#Preview {
    BackButton()
}
