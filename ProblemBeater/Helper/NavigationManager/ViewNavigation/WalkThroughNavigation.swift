//
//  WalkThroughNavigation.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 01/06/25.
//

import SwiftUICore

struct WalkThroughNavigation: Navigate {
    
    var typeId: String {
        String(describing: WalkThroughNavigation.self)
    }
    
    func destinationView() -> AnyView {
        AnyView(WalkthroughScreen())
    }
}
