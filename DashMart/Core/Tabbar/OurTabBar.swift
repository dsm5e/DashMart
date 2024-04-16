//
//  OurTabBar.swift
//  DashMart
//
//  Created by Ваня Науменко on 15.04.24.
//

import SwiftUI

struct OurTabBar: View {
    var body: some View {
        TabView {
            Home()
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
            Account()
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
    OurTabBar()
}
