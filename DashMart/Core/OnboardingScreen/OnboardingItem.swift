//
//  OnboardingItem.swift
//  HomeChaleng
//
//  Created by Ваня Науменко on 15.04.24.
//

import SwiftUI

// MARK: - OnboardingItem

struct OnboardingItem: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    var description: String
}

let onboardingData: [OnboardingItem] = [
    OnboardingItem(imageName: "onboarding_1", title: "Discover New Styles", description: "Explore our latest collection and discover new styles that suit your taste."),
    OnboardingItem(imageName: "onboarding_2", title: "Get Inspired", description: "Get inspired by our curated looks and find the perfect outfit for any occasion."),
    OnboardingItem(imageName: "onboarding_3", title: "Easy Shopping", description: "Enjoy hassle-free shopping with easy navigation, secure payments, and fast delivery.")
]