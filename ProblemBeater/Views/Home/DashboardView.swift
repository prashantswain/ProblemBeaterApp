//
//  HomeScreen.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var userDetail: SharedUserDetail
    @EnvironmentObject var loadingState: LoadingState
    @StateObject var viewModel = DashBoardViewModel()
    @State var showLoginSuccessToast = false
   
    
    init(viewModel:DashBoardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            Text(userDetail.user?.name ?? "")
            AppButton(text: "Logout") {
                viewModel.loadingState = loadingState
                Task {
                    await viewModel.fetchData()
                }
            }
        }
        .padding()
        .navigationBarHidden(true)
        .onChange(of: viewModel.logoutSucess) { oldValue, newValue in
            if newValue {
                navManager.logout()
                userDetail.isUserLoggedIn = false
            }
        }
    }
}

#Preview {
    DashboardView(viewModel: DashBoardViewModel())
        .environmentObject(NavigationManager())
        .environmentObject(SharedUserDetail())
}
