//
//  SideMenuView.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 02/06/25.
//

import SwiftUI

class DrawerManager: ObservableObject {
    @Published var isOpen: Bool = false
}

struct SideMenuView: View {
    @EnvironmentObject var drawerManager: DrawerManager
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var userDetail: SharedUserDetail
    @EnvironmentObject var loadingState: LoadingState
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 20) {
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [.appColor1, .appColor2], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                    HStack {
                        VStack(alignment: .leading, spacing: 20) {
                            Spacer()
                            Image("logo")
                                .resizable()
                                .frame(width: 200, height: 120)
                                .scaledToFit()
                            Text("Problem Beater")
                                .font(.system(.title2, design: .rounded))
                                .bold()
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 16)
                            
                        }
                        .padding(.horizontal, 16)
                        Spacer()
                    }
                }
                .ignoresSafeArea()
                .frame(height: 250)
                
                VStack(alignment: .leading, spacing: 20) {
                    ScrollView {
                        ForEach(Menu.allCases, id: \.rawValue) { menu in
                                getMenuItem(menu: menu)
                        }
                        logoutButton()
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 10))
            }
            .frame(maxWidth: 250)
            .background(.white)
            .edgesIgnoringSafeArea(.all)
            Spacer()
        }
        
    }
    
    @ViewBuilder
    func getMenuItem(menu: Menu) -> some View {
        Button {
            //
        } label: {
            HStack {
                Image(systemName: menu.icon)
                    .scaledToFit()
                    .foregroundStyle(.gray)
                Text(menu.title)
                    .font(.system(.body, design: .rounded))
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 6)
                    .foregroundStyle(.black)
                Image(systemName: "chevron.right.circle")
                    .scaledToFit()
                    .foregroundStyle(.gray.opacity(0.5))
                    .frame(width: 25, height: 25, alignment: .trailing)
            }
            .frame(height: 65)
        }
//        .background(.black)

    }
    
    @ViewBuilder
    func logoutButton() -> some View {
        @State var isPressed: Bool = false
        HStack {
            Button {
    //            onClick()
            } label: {
                Text("Logout")
                    .font(.system(size: 20, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: 120)
            }
            .frame(height: 15)
            .padding()
            .background(
                LinearGradient(colors: [.appColor2, .appColor1], startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(Capsule())
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.easeIn(duration: 0.1)) {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.easeOut(duration: 0.1)) {
                            isPressed = false
                        }
                    }
            )
            Spacer()
        }
        
    }
}

#Preview {
    SideMenuView()
}


enum Menu: String, CaseIterable {
    case editProfile
    case purchasedCource
    case paymentHistory
    case rateApp
    case shareApp
    case AboutUs
    
    var title: String {
        switch self {
        case .editProfile: return "Edit Profile"
        case .purchasedCource: return "Purchased Cource"
        case .paymentHistory: return "Payment History"
        case .rateApp: return "Rate App"
        case .shareApp: return "Share App"
        case .AboutUs: return "About Us"
        }
    }
    
    var icon: String {
        switch self {
        case .editProfile: return "pencil"
        case .purchasedCource: return "exclamationmark.lock"
        case .paymentHistory: return "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case .rateApp: return "star.fill"
        case .shareApp: return "rectangle.portrait.and.arrow.forward"
        case .AboutUs: return "person.3.fill"
        }
    }
}
