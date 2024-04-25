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

    OnboardingItem(imageName: "onboardingFinel_1", title: "20% Discount\nNew Arrival Product", description: "Explore our latest collection and discover new styles that suit your taste."),
    OnboardingItem(imageName: "onboardingFinel_2", title: "Take Advantage\nOf The Offer Shopping", description: "Get inspired by our curated looks and find the perfect outfit for any occasion."),
    OnboardingItem(imageName: "onboardingFinel_3", title: "All Types Offers\nWithin Your Reach", description: "Enjoy hassle-free shopping with easy navigation and fast delivery.")

]
