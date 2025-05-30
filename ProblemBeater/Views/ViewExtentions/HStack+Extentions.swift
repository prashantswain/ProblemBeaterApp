//
//  HStack+Extentions.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import SwiftUI

extension HStack {
    func imageTextFieldModdifier() -> some View {
        self
            .frame(height: 30)
            .padding()
            .overlay(
                Capsule().stroke(appColor1, lineWidth: 2)
            )
            .clipShape(Capsule())
    }
}
