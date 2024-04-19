//
//  ProductPhoto.swift
//  DashMart
//
//  Created by Максим Самороковский on 17.04.2024.
//

import SwiftUI

struct ProductPhoto: View {
    let image: String
    let titleName: String
    let price: String
    let titleDescription: String
    let descriptionText: String
    
    var body: some View {
        VStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(height: 286)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(titleName)
                        .font(.system(size: 16))
                        .foregroundStyle(Color(hex: "#393F42"))
                    Text(price)
                        .font(.system(size: 18))
                        .foregroundStyle(Color(hex: "#393F42"))
                }
                .padding(.horizontal)
                Spacer()
                
                Button(action: {
                    // action
                }) {
                    Image("heart")
                    
                }
                .frame(width: 46, height: 46)
                .background(Color(hex: "#939393").opacity(0.1))
                .clipShape(Circle())
                .padding(.horizontal)
                
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(titleDescription)
                    .font(.system(size: 16))
                .foregroundStyle(Color(hex: "#393F42"))
                
                Text(descriptionText)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: "#393F42"))
                    .lineSpacing(5)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ProductPhoto(image: "erpL", titleName: "Air pods max by Apple", price: "$ 1999,99", titleDescription: "Description of product", descriptionText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquet arcu id tincidunt tellus arcu rhoncus, turpis nisl sed. Neque viverra ipsum orci, morbi semper. Nulla bibendum purus tempor semper purus. Ut curabitur platea sed blandit. Amet non at proin justo nulla et. A, blandit morbi suspendisse vel malesuada purus massa mi. Faucibus neque a mi hendrerit.")
}
