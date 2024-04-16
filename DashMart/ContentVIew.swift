//
//  ContentVIew.swift
//  DashMart
//
//  Created by Victor on 16.04.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var router = RouterService()
    
    
    var body: some View {
        Group {
            switch router.screen {
            case .onbording:
                OnboardingView(router: router)
            case .authorization:
                AuthorizeView(router: router)
            case .main:
                OurTabBar(router: router)
            }
        }
        .animation(.smooth, value: router.screen)
    }
}
