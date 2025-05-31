//
//  ToastView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 30/05/25.
//

import SwiftUI

struct ToastView: View {
    var message: String

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text(message)
                        .font(.system(.title2, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: -40, trailing: 0))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(colors: [.appColor2, .appColor1], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                )
                
            }
            Spacer()
        }
        
    }
}

#Preview {
    ToastView(message: "Welcome")
}
