//
//  HomeScreenNavigation.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 01/06/25.
//
import SwiftUI

struct HomeScreenNavigation: Navigate {
    
    var typeId: String {
        String(describing: HomeScreenNavigation.self)
    }
    var showToast: Bool = false
    var toastMessage: String = ""

    func destinationView() -> AnyView {
        let viewModel = HomeScreenViewModel(showLoginToast: showToast, wecomeMessage: toastMessage)
        return AnyView(AppDrawerContainer(viewModel: viewModel))
    }
}
