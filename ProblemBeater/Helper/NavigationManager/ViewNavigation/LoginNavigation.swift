//
//  LoginNavigation.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 01/06/25.
//
import SwiftUI

struct LoginNavigation: Navigate {
    let id = UUID()
    var typeId: String {
        "\(String(describing: LoginNavigation.self))-\(id.uuidString)"
    }
    var showToast: Bool = false
    var toastMessage: String = ""

    func destinationView() -> AnyView {
        let viewModel = LoginViewModel(showToast: showToast, toastMessage: toastMessage)
        return AnyView(LoginView(viewModel: viewModel).id(UUID()))
    }
}
