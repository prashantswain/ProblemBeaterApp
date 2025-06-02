//
//  AppDrawerContainer.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 02/06/25.
//

import SwiftUI

struct AppDrawerContainer: View {
    @StateObject private var drawerManager = DrawerManager()
    @StateObject private var homeViewModel: HomeScreenViewModel
    @EnvironmentObject var loadingState: LoadingState
    @EnvironmentObject var userDetail: SharedUserDetail
    
    init(viewModel: HomeScreenViewModel) {
        _homeViewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            AppHomeScreen()
                .environmentObject(drawerManager)
//                .offset(x: drawerManager.isOpen ? 0 : 0)
                .disabled(drawerManager.isOpen)
            
            if drawerManager.isOpen {
                Color.black.opacity(0.3)
                    .onTapGesture {
                        withAnimation {
                            drawerManager.isOpen = false
                        }
                    }
                    .ignoresSafeArea()
            }
            
            SideMenuView()
                .frame(width: 250)
                .offset(x: drawerManager.isOpen ? 0 : -250)
                .animation(.easeInOut, value: drawerManager.isOpen)
        }
        .environmentObject(homeViewModel)
    }
}

#Preview {
    AppDrawerContainer(viewModel: HomeScreenViewModel(showLoginToast: true, wecomeMessage: ""))
        .environmentObject(LoadingState())
        .environmentObject(SharedUserDetail())
}
