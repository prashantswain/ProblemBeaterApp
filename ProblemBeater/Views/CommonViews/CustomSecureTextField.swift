//
//  CustomSecureTextField.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct CustomSecureTextField: View {
    let placeHolderText: String
    @Binding var text: String
    @State private var isSecure: Bool = true
    var body: some View {
        HStack {
                Image(systemName: "key.fill")
                    .scaledToFit()
                    .foregroundStyle(.gray)
            Group {
                if isSecure {
                    SecureField(placeHolderText, text: $text)
                } else {
                    TextField(placeHolderText, text: $text)
                }
            }
            .font(.system(.title3, design: .rounded))
            .frame(maxWidth: .infinity)
            Button {
                isSecure.toggle()
            } label: {
                Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                    .scaledToFit()
                    .foregroundStyle(.gray)
            }

            
        }
        .imageTextFieldModdifier()
    }
}

#Preview {
    CustomSecureTextField(placeHolderText: "Password", text: .constant(""))
}
