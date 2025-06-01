//
//  ForgotPasswordNavigation.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 01/06/25.
//

import SwiftUICore

struct ForgotPasswordNavigation: Navigate {
    var typeId: String {
        String(describing: ForgotPasswordNavigation.self)
    }
    func destinationView() -> AnyView {
        return AnyView(ForgotPasswordView())
    }
}
