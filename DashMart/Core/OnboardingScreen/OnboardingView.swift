//
//  OnboardingView.swift
//  DashMart
//
//  Created by Ваня Науменко on 15.04.24.
//

import SwiftUI

// MARK: - OnboardingView

struct OnboardingView: View {
    @State private var currentPageIndex = 0
    private let router: RouterService
    
    init(router: RouterService) {
        self.router = router
    }

    var body: some View {
        VStack(alignment: .leading) {
            TabView(selection: $currentPageIndex) {
                ForEach(onboardingData.indices, id: \.self) { index in
                    OnboardingPage(onboardingItem: onboardingData[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            
            Spacer()

            HStack {
                PageIndicator(numberOfPages: onboardingData.count, currentIndex: currentPageIndex)
                Spacer()

                Button(action: {
                    if currentPageIndex < onboardingData.count - 1 {
                        currentPageIndex += 1
                    } else {
                        router.openApp()
                    }
                }) {
                    Image(systemName: "arrowtriangle.right.circle")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(.black)
                }
            }
            .padding()
        }
    }
}

// MARK: - OnboardingView_Previews

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(router: RouterService())
    }
}
