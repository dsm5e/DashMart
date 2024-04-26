//
//  ContentView.swift
//  DashMart
//
//  Created by Victor on 16.04.2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var router = RouterService()
    @State private var isSplashScreenPresented = true
    @State private var size = 0.9
    @State private var opacity = 0.8
    
    
    var body: some View {
        ZStack {
            Group {
                switch router.screen {
                case .onbording:
                    OnboardingView(router: router)
                case .authorization:
                    AuthorizeView(router: router)
                case .main:
                    TabBar(router: router)
                }
            }
            .animation(.smooth, value: router.screen)
            
            if isSplashScreenPresented {
                splashScreen
                    .zIndex(.infinity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation {
                                self.isSplashScreenPresented = false
                            }
                        }
                    }
            }
        }
        
    }
    
    private var splashScreen: some View {
        VStack {
            VStack {
                Image("splash_icon_square")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .padding(.bottom, .s8)
                Text("DashMart")
                    .fontWeight(.bold)
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.25)) {
                    self.size = 1
                    self.opacity = 1
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("GreenSecondary"))
    }
    
}
