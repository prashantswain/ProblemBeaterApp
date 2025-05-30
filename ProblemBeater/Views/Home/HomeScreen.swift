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
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            AppButton(text: "Logout") {
                Task {
                    await viewModel.fetchData()
                    appUserDefault.isUserLoggedIn = false
                    navManager.logout()
                }
            }
        }
        .padding()
        .navigationBarHidden(true)
        .spinnerOverlay(isLoading: viewModel.isLoading)
    }
}

#Preview {
    HomeScreen()
}
