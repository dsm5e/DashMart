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
                    Text("Home")
                }
            WishList()
                .tabItem {
                    Image("heart")
                    Text("WishList")
                }
            Manager()
                .tabItem {
                    Image("paper")
                    Text("WishList")
                }
            Account()
                .tabItem {
                    Image("profile")
                    Text("WishList")
                }
        }
        .tint(.black)
    }
}

#Preview {
    OurTabBar()
}
