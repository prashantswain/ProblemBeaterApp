//
//  LoginView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var loadingState: LoadingState
    @State var showSuccessToast = false
    @StateObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Let's Sign In.!")
                    .font(.system(size: 32, design: .rounded))
                    .bold()
                VStack(alignment: .leading, spacing: 16) {
                    TextFieldWithImage(placeHolderText: "Email", text: $viewModel.email, showIcon: true, iconName: "envelope.fill")
                        .keyboardType(.emailAddress)
                    CustomSecureTextField(placeHolderText: "Password", text: $viewModel.password)
                    Button {
                        // Forgot Password Action
                        DispatchQueue.main.async {
//                            navManager.path.append(AnyNavigate(ForgotPasswordNavigation()))
                            navManager.navigate(to: ForgotPasswordNavigation())
                        }
                    } label: {
                        Text("Forgot Password?")
                            .font(.system(size: 16, design: .rounded))
                            .padding(.horizontal, 10)
                    }
                }
                AppButton(text: "Sign In") {
                    // Sign In Action
                    viewModel.loadingState = loadingState
                    Task {
                        await viewModel.login()
                    }
                }
                .padding(.top, 30)
                
                HStack {
                    Text("Don't have an account?")
                        .font(.system(size: 16, design: .rounded))
                    Button {
                        // Forgot Password Action
                        navManager.path.append(AnyNavigate(SignUpNavigation()))
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
                print("Panchal failed")
            if viewModel.showToast {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showSuccessToast = true
                        self.viewModel.showToast.toggle()
                    }
                }
            }
            .spinnerOverlay(isLoading: loadingState.isLoading)
            .onChange(of: viewModel.isLoggedInSuucess) { oldValue, newValue in
                if newValue {
                    Task {
                        await navManager.goToHome(showToastMessage: true, message: "Login Successfully")
                    }
                }
            }
            .showToasMessage(isShowing: $showSuccessToast, message: viewModel.toastMessage)
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel())
}
