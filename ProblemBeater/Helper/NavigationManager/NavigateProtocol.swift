//
//  NavigateProtocol.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 01/06/25.
//
import SwiftUI


@MainActor
protocol Navigate: Hashable {
    func destinationView() -> AnyView
    var typeId: String { get }
}

@MainActor
struct AnyNavigate: Hashable {
    private let _destinationView: () -> AnyView
    private let _typeId: String

    init<T: Navigate & Hashable>(_ base: T) {
        self._destinationView = base.destinationView
        self._typeId = base.typeId
    }

    func destinationView() -> AnyView {
        _destinationView()
    }
    
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(_typeId)
    }

    nonisolated static func == (lhs: AnyNavigate, rhs: AnyNavigate) -> Bool {
        lhs._typeId == rhs._typeId
    }
}

