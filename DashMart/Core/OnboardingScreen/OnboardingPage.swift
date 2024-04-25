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
        VStack {
            Image(onboardingItem.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(OnboardingShape())
                .padding(.horizontal, 10)


            Text(onboardingItem.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)

            Text(onboardingItem.description)
                .font(.body)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 50)
    }
}

#Preview {
    OnboardingPage(onboardingItem: OnboardingItem(imageName: "onboardingFinel_1", title: "example", description: "exampl"))
}
