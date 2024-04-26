//
//  OnboardingPage.swift
//  HomeChaleng
//
//  Created by Ваня Науменко on 15.04.24.
//

import SwiftUI

struct OnboardingPage: View {
    var onboardingItem: OnboardingItem

    var body: some View {
        VStack(alignment: .leading) {
            Image(onboardingItem.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(OnboardingShape())
                .padding(.s20)

            Text(onboardingItem.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, .s12)
                .padding(.horizontal, .s24)

            Text(onboardingItem.description)
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
                .padding(.horizontal, .s24)
        }
        
    }
}

#Preview {
    OnboardingPage(onboardingItem: OnboardingItem(imageName: "onboardingFinel_1", title: "example", description: "exampl"))
}
