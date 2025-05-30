//
//  WalkthroughScreen.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 28/05/25.
//

import SwiftUI

struct WalkthroughScreen: View {
    @EnvironmentObject var navManager: NavigationManager
    @State private var isAnimating = false
    @State private var currntPage = 0
    @State private var showLogin = false
    var body: some View {
        VStack {
            TabView(selection: $currntPage) {
                ForEach(OnboardingPage.allCases, id: \.rawValue) { page in
                    pageView(for: page)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.spring(), value: currntPage)
            // Indicator
            HStack(spacing: 12) {
                ForEach(0..<OnboardingPage.allCases.count, id: \.self) { index in
                    Circle()
                        .fill(currntPage == index ? appColor : Color.gray.opacity(0.5))
                        .frame(width: currntPage == index ? 12 : 8, height: currntPage == index ? 12 : 8, alignment: .center)
                        .animation(.spring(), value: currntPage)
                }
            }
            .padding(20)
            Button {
                withAnimation(.spring()) {
                    if currntPage < OnboardingPage.allCases.count - 1 {
                        currntPage += 1
                    } else {
                        appUserDefault.isAppInstalled = true
                        // Navigate to Login Screen
                        Task {
                            await navManager.goToLogin()
                        }
                    }
                }
            } label: {
                Text(currntPage < OnboardingPage.allCases.count - 1 ? "Next" : "Get started")
                    .font(.system(size: 28, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(
                        LinearGradient(colors: [appColor1, appColor2.opacity(0.6) , appColor3.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 5)
                
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)
        }
        .navigationBarHidden(true)
        .onAppear {
            isAnimating = true
        }
    }
    
    @ViewBuilder
    func pageView(for page: OnboardingPage) -> some View {
        VStack(spacing: 30) {
            VStack(spacing: 20) {
               // Image
                Image(systemName: page.detail.iamge)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(
                        LinearGradient(colors: [appColor1, appColor2.opacity(0.6) , appColor3.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                    )
                    .padding()
                Spacer()
                VStack {
                    // Title
                     Text(page.detail.title)
                         .font(.system(.largeTitle, design: .rounded))
                         .bold()
                         .foregroundStyle(.secondary)
                         .multilineTextAlignment(.center)
                         .padding(.horizontal)
                         .opacity(isAnimating ? 1 :0)
                         .offset(y: isAnimating ? 0 : 20)
                         .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
                     
                     // Description
                     Text(page.detail.description)
                         .font(.system(.title3, design: .rounded))
                         .italic()
                         .foregroundStyle(.primary)
                         .multilineTextAlignment(.center)
                         .padding(.horizontal, 32)
                         .opacity(isAnimating ? 1 :0)
                         .offset(y: isAnimating ? 0 : 20)
                         .animation(.spring(dampingFraction: 0.8).delay(0.3), value: isAnimating)
                }
            }
        }
    }
}

#Preview {
    WalkthroughScreen()
}
