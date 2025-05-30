//
//  LoginView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var navManager: NavigationManager
    @State private var email: String = ""
    @State private var password: String = ""
    
    @ObservedObject var viewModel = LoginViewModel()
    var body: some View {
            VStack(alignment: .leading) {
                Text("Let's Sign In.!")
                    .font(.system(size: 32, design: .rounded))
                    .bold()
                VStack(alignment: .leading, spacing: 16) {
                    TextFieldWithImage(placeHolderText: "Email", text: $email, showIcon: true, iconName: "envelope.fill")
                    CustomSecureTextField(placeHolderText: "Password", text: $password)
                    Button {
                        // Forgot Password Action
                        DispatchQueue.main.async {
                            navManager.path.append(NavigationScreen.forgotPassword)
                        }
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 16, design: .rounded))
                            .padding(.horizontal, 10)
                    }
                }
                AppButton(text: "Sign In") {
                    // Sign In Action
                    Task {
                        await viewModel.fetchData()
                        await navManager.goToHome()
                    }
                }
                .padding(.top, 30)
                
                HStack {
                    Text("Don't have an account?")
                        .font(.system(size: 16, design: .rounded))
                    Button {
                        // Forgot Password Action
                            navManager.path.append(NavigationScreen.signUp)
                    } label: {
                        Text("Sign Up")
                            .font(.system(size: 16, design: .rounded))
                            .padding(.horizontal, -2)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 0, trailing: 0))
            }
            .padding()
            .navigationBarHidden(true)
            .onAppear {
                print("Login path :\(navManager.path)")
            }
            .spinnerOverlay(isLoading: viewModel.isLoading)
    }
}

#Preview {
    LoginView()
}
