//
//  AppHomeScreen.swift
//  ProblemBeater
//
//  Created by Prashant Swain on 02/06/25.
//

import SwiftUI

struct AppHomeScreen: View {
    @State var selectedTab: TabItem = .Home
    @EnvironmentObject var navManager: NavigationManager
    @EnvironmentObject var userDetail: SharedUserDetail
    @EnvironmentObject var loadingState: LoadingState
    @EnvironmentObject var drawerManager: DrawerManager
    @ObservedObject var viewModel = HomeScreenViewModel()
    @State var showLoginSuccessToast = false
    var body: some View {
        ZStack(alignment: .bottom) {

            TabView(selection: $selectedTab) {
                ForEach(TabItem.allCases, id: \.rawValue) { tabItem in
                    getViewFor(tabItem)
                        .tag(tabItem)
                }
            }
            
            InteractiveTabBar(activeTab: $selectedTab)
            VStack {
                HStack {
                    Button {
                        drawerManager.isOpen = true
                    } label: {
                        Image(systemName: "text.justify.left")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.appColor1)
                            .padding()
                    }
                    Spacer()
                }
               
                Spacer()
            }
            
        }
        .navigationBarHidden(true)
        .showToasMessage(isShowing: $showLoginSuccessToast, message: viewModel.welcomeMessage)
        .spinnerOverlay(isLoading: loadingState.isLoading)
        .onAppear {
            if viewModel.showLoginToast {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showLoginSuccessToast = true
                    viewModel.showLoginToast = false
                }
            }
        }
    }
    
    func getViewFor(_ tabItem: TabItem) -> some View {
        switch tabItem {
        case .Home:
            return AnyView(DashboardView(viewModel: DashBoardViewModel()))
        case .Learning:
            return AnyView(EmptyView())
        case .Search:
            return AnyView(EmptyView())
        case .Profile:
            return AnyView(ProfileView())
        }
    }
}

struct InteractiveTabBar: View {
    @Binding var activeTab: TabItem
    @Namespace private var animation
    @State private var tabButtonLocations: [CGRect] = Array(repeating: .zero, count: TabItem.allCases.count)
    @State var activeDraggingTab: TabItem?
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabButton(tab: tab)
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 15)
        .padding(.bottom, 10)
        .background {
            Rectangle()
                .fill(.background.shadow(.drop(color: .primary.opacity(0.2) ,radius: 5)))
                .ignoresSafeArea()
                .padding(.top, 20)
        }
        .coordinateSpace(.named("TABBAR"))
    }
    
    @ViewBuilder
    func TabButton(tab: TabItem) -> some View {
        let isActive = (activeDraggingTab ?? activeTab) == tab
        VStack(spacing: 6) {
            Image(systemName: tab.itemIcon)
                .symbolVariant(.fill)
                .frame(width: isActive ? 50 : 25, height: isActive ? 50 : 25)
                .background {
                    if isActive {
                        Circle()
                            .fill(.appColor1)
                            .matchedGeometryEffect(id: "ActiveTab", in: animation)
                    }
                }
                .frame(width: 25, height: 25, alignment: .bottom)
                .foregroundStyle(isActive ? .white : .primary)
            Text(tab.rawValue)
                .font(.caption2)
                .foregroundColor(isActive ? .appColor1 : .primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .onGeometryChange(for: CGRect.self, of: {
            $0.frame(in: .named("TABBAR"))
        }, action: { newValue in
            tabButtonLocations[tab.index] = newValue
        })
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) {
                activeTab = tab
            }
        }
        .gesture(
            DragGesture(coordinateSpace: .named("TABBAR"))
                .onChanged { value in
                    let location = value.location
                    if let index = tabButtonLocations.firstIndex(where: {$0.contains(location)}) {
                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                            activeDraggingTab = TabItem.allCases[index]
                        }
                    }
                }.onEnded { _ in
                    // return current value
                    if let activeDraggingTab {
                        activeTab = activeDraggingTab
                    }
                    activeDraggingTab = nil
                },
            isEnabled: activeTab == tab
        )
    }
}

#Preview {
    AppHomeScreen()
        .environmentObject(NavigationManager())
        .environmentObject(SharedUserDetail())
        .environmentObject(LoadingState())
        .environmentObject(DrawerManager())
}

enum TabItem: String, CaseIterable {
    case Home
    case Learning
    case Search
    case Profile
    
    var itemIcon: String {
        switch self {
            case .Home:
            return "house"
        case .Learning:
            return "book"
        case .Search:
            return "magnifyingglass"
        case .Profile:
            return "person.circle"
        }
    }
    
    var index: Int {
        return Self.allCases.firstIndex(of: self) ?? 0
    }
}
