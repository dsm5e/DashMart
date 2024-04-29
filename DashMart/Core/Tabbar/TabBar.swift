//
//  TabBar.swift
//  DashMart
//
//  Created by Victor on 16.04.24.
//

import SwiftUI

struct TabBar: View {
    
    struct Tab: Identifiable {
        let id = UUID()
        let title: String
        let tag: Int
    }
    
    private let router: RouterService
    @State private var selection = 0
    @ObservedObject private var managerService = ManagerService.shared
    var tabs: [Tab] {
        if managerService.isManager {
            return [
                .init(title: "Home", tag: 0),
                .init(title: "WishList", tag: 1),
                .init(title: "Account", tag: 2)
            ]
        } else {
            return [
                .init(title: "Home", tag: 0),
                .init(title: "WishList", tag: 1),
                .init(title: "Manager", tag: 2),
                .init(title: "Account", tag: 3)
            ]
        }
    }
    
    init(router: RouterService) {
        self.router = router
    }
    
    var body: some View {
        TabView(selection: $selection) {
            if managerService.isManager {
                HomeScreen()
                    .tabItem {
                        Image(selection == 0 ? .Tab.Green.home : .Tab.home)
                        Text("Home")
                    }
                    .tag(0)
                WishlistScreen()
                    .tabItem {
                        Image(selection == 1 ? .Tab.Green.heart : .Tab.heart)
                        Text("WishList")
                    }
                    .tag(1)
                ManagerScreen()
                    .tabItem {
                        Image(selection == 2 ? .Tab.Green.paper : .Tab.paper)
                        Text("Manager")
                    }
                    .tag(2)
                AccountView(router: router)
                    .tabItem {
                        Image(selection == 3 ? .Tab.Green.profile : .Tab.profile)
                        Text("Account")
                    }
                    .tag(3)
            } else {
                HomeScreen()
                    .tabItem {
                        Image(selection == 0 ? .Tab.Green.home : .Tab.home)
                        Text("Home")
                    }
                    .tag(0)
                WishlistScreen()
                    .tabItem {
                        Image(selection == 1 ? .Tab.Green.heart : .Tab.heart)
                        Text("WishList")
                    }
                    .tag(1)
                AccountView(router: router)
                    .tabItem {
                        Image(selection == 3 ? .Tab.Green.profile : .Tab.profile)
                        Text("Account")
                    }
                    .tag(2)
            }
        }
        .tint(.black)
        .onChange(of: managerService.isManager) {
            value in
            
            selection = value ? 3 : 2
        }
        .onAppear {
            LocationService.shared.requestAuthorize()
        }
    }
}

#Preview {
    TabBar(router: RouterService())
}
