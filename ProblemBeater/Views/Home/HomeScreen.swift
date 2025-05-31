//
//  HomeScreen.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var navManager: NavigationManager
    @ObservedObject var viewModel = HomeScreenViewModel()
    @State var showLoginSuccessToast = false
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            AppButton(text: "Logout") {
                Task {
                    await viewModel.fetchData()
                }
            }
        }
        .padding()
        .navigationBarHidden(true)
        .spinnerOverlay(isLoading: viewModel.isLoading)
        .showToasMessage(isShowing: $showLoginSuccessToast, message: viewModel.welcomeMessage)

        .onChange(of: viewModel.logoutSucess) { oldValue, newValue in
            if newValue {
                navManager.logout()
                appUserDefault.isUserLoggedIn = false
            }
        }
        .onAppear{
            if viewModel.showLoginToast {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showLoginSuccessToast = true
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
