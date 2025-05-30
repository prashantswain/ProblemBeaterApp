//
//  Onboard.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//
import SwiftUI
struct OnboardPageDetail {
    let title: String
    let description: String
    let iamge: String
}

enum OnboardingPage: Int, CaseIterable {
    case page1
    case page2
    case page3
    
    var detail: OnboardPageDetail {
        switch self {
        case .page1:
            return OnboardPageDetail(title: "Learn at Your Pace", description: "Personalized lessons designed to match your learning speed - whether you're revising basics or mastering new concepts.", iamge: "function")
        case .page2:
            return OnboardPageDetail(title: "Track Your Progress", description: "Set goals, earn achievements, and watch your skills grow with detailed insights into your learning journey.", iamge: "compass.drawing")
        case .page3:
            return OnboardPageDetail(title: "Interactive & Engaging", description: "Boost retention with quizzes, videos, and challenges that make learning fun and effective.", iamge: "x.squareroot")
        }
    }
}
