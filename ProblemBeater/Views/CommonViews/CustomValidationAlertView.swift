//
//  CustomValidationAlertView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 31/05/25.
//

import SwiftUI

struct CustomValidationAlertView: View {
    @ObservedObject var manager = ValidationErrorManager.shared
    var body: some View {
        ZStack {}
            .alert(isPresented: $manager.showError) {
            Alert(
                title: Text(appName),
                message: Text(manager.message ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    CustomValidationAlertView()
}
