//
//  DetailScreen.swift
//  DashMart
//
//  Created by Максим Самороковский on 17.04.2024.
//

import SwiftUI

struct DetailScreen: View {
    var body: some View {
        VStack {
            TitleDetail()
                .padding()
            ProductPhoto(
                image: "erpL",
                titleName: "Air pods max by Apple",
                price: "$ 1999,99",
                titleDescription: "Description of product",
                descriptionText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu rhoncus, turpis nisl sed. Neque viverra ipsum orci, morbi semper. Nulla bibendum purus tempor semper purus. Ut curabitur platea sed blandit. Amet non at proin justo nulla et. A, blandit morbi suspendisse vel malesuada purus massa mi. Faucibus neque a mi hendrerit.")
        }
        Spacer()
        
        Divider()
            .padding(.bottom)
        HStack {
            ButtonsDetail(title: "Add to Cart", type: .add) {
                // action
            }

            ButtonsDetail(title: "Buy Now", type: .buy) {
                // action
            }
        }
    }
}

#Preview {
    DetailScreen()
}
