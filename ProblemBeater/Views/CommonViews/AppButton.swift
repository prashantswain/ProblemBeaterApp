//
//  AppButton.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct AppButton: View {
    let text: String
    var onClick: ()->Void
    @State var isPressed: Bool = false
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .font(.system(size: 25, design: .rounded))
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 30)
        .padding()
        .background(
            LinearGradient(colors: [.appColor2, .appColor1], startPoint: .leading, endPoint: .trailing)
        )
        .clipShape(Capsule())
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
    AppButton(text: "Click", onClick: {})
}
