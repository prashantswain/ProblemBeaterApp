//
//  CustomPickerView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct CustomPickerView: View {
    let placeHolderText: String
    var dataSources: [String]
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
            HStack {
                Text(placeHolderText)
                    .font(.system(.title3, design: .rounded))
                Spacer()
            }
            Spacer()
            Picker("", selection: $text) {
                ForEach(dataSources, id: \.self) { data in
                    Text(data)
                        .font(.system(.title3, design: .rounded))
                        .frame(maxWidth: .infinity)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
        .imageTextFieldModdifier()
    }
}

#Preview {
    CustomPickerView(placeHolderText: "Gender", dataSources: genders, text: .constant(""))
}
