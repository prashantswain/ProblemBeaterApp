//
//  SignUpNavigation.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 01/06/25.
//

import SwiftUI

struct SignUpNavigation: Navigate {
    
    var typeId: String {
        String(describing: SignUpNavigation.self)
    }

    func destinationView() -> AnyView {
        return AnyView(RegistrationView())
    }
}
