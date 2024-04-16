//
//  OurTabBar.swift
//  DashMart
//
//  Created by Ваня Науменко on 15.04.24.
//

import SwiftUI

struct OurTabBar: View {
    
    private let router: RouterService
    
    init(router: RouterService) {
        self.router = router
    }
    
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Image("home")
                        .resizable()
                        .scaledToFit()
                    Text("Home")
                }
            WishList()
                .tabItem {
                    Image("heart")
                        .resizable()
                        .scaledToFit()
                    Text("WishList")
                }
            Manager()
                .tabItem {
                    Image("paper")
                        .resizable()
                        .scaledToFit()
                    Text("Manager")
                }
            Account(router: router)
                .tabItem {
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                    Text("Account")
                }
        }
        .tint(.green)
    }
}

#Preview {
    OurTabBar(router: RouterService())
}
