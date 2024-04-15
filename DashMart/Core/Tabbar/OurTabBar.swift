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
            Home().tag("1")
                .tabItem { Label("Everyone", systemImage: "person.3") }
            WishList().tag("2")
                .tabItem { Label("Everyone", systemImage: "person.3") }
            Manager().tag("3")
                .tabItem { Label("Everyone", systemImage: "person.3") }
            Account().tag("4")
                .tabItem { Label("Everyone", systemImage: "person.3") }
        }
    }
}

#Preview {
    OurTabBar()
}
