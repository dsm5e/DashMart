//
//  TabBar.swift
//  DashMart
//
//  Created by Victor on 16.04.24.
//

import SwiftUI

struct TabBar: View {
    
    private let router: RouterService
    @State private var selection = 0
    
    init(router: RouterService) {
        self.router = router
    }
    
    var body: some View {
        TabView(selection: $selection) {
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
            Manager()
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
        }
        .tint(.black)
    }
}

#Preview {
    TabBar(router: RouterService())
}
