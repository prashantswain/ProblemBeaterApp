//
//  ForgotPasswordView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject var navManager: NavigationManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @ObservedObject var viewModel = ForgotPasswordViewModel()
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                BackButton()
                    .environmentObject(navManager)
                Spacer()
                Text("Forgot Password")
                    .font(.system(size: 32, design: .rounded))
                    .bold()
                VStack(spacing: 16) {
                    TextFieldWithImage(placeHolderText: "Email", text: $email, showIcon: true, iconName: "envelope.fill")
                    CustomSecureTextField(placeHolderText: "Password", text: $password)
                    CustomSecureTextField(placeHolderText: " Confirm Password", text: $confirmPassword)
                }
                AppButton(text: "Save") {
                    Task {
                        await viewModel.fetchData()
                        await navManager.goToLogin()
                    }
                }
                .padding(.top, 30)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .spinnerOverlay(isLoading: viewModel.isLoading)
        .navigationBarHidden(true)
    }
}

#Preview {
    ForgotPasswordView()
}
