//
//  TextFieldWithImage.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct TextFieldWithImage: View {
    let placeHolderText: String
    @Binding var text: String
    var showIcon: Bool = false
    var iconName: String = ""
    
    var body: some View {
        HStack {
            if showIcon {
                Image(systemName: iconName)
                    .scaledToFit()
                    .foregroundStyle(.gray)
            }
            TextField(placeHolderText, text: $text)
                .font(.system(.title3, design: .rounded))
                .frame(maxWidth: .infinity)
        }
        .imageTextFieldModdifier()
    }
}

#Preview {
    TextFieldWithImage(placeHolderText: "Email", text: .constant(""), showIcon: true, iconName: "envelope.fill")
}
