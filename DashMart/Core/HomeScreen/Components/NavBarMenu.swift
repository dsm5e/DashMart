//
//  NavBarMenu.swift
//  DashMart
//
//  Created by Максим Самороковский on 15.04.2024.
//

import SwiftUI

struct NavBarMenu: View {
    @State private var badgeCountBuy = 2
    @State private var badgeCountBell = 0
    
    private enum Drawing {
        static let titleSecondColor = Color(hex: "#C8C8CB")
        static let titleBaseColor = Color(hex: "#393F42")
        static let titleSecondFontSize: CGFloat = 10
        static let titleBaseFontSize: CGFloat = 12
        static let imageBuy: String = "buy"
        static let imageBell: String = "bell"
        static let buttonWidth: CGFloat = 28
        static let buttonHeigth: CGFloat = 28
        static let colorButton = Color(hex: "#200E32")
        static let titleButtonFontSize: CGFloat = 7
        static let badgeColor = Color(hex: "#D65B5B")
        static let badgeTitleColor = Color(hex: "#FFFFFF")
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Delivery address")
                    .font(.system(size: Drawing.titleSecondFontSize))
                    .foregroundStyle(Drawing.titleSecondColor)
                
                HStack {
                    Text("Salatiga City, Central Java")
                        .font(.system(size: Drawing.titleBaseFontSize))
                        .foregroundStyle(Drawing.titleBaseColor)
                    
                    Button {
                        // action
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: Drawing.titleButtonFontSize))
                            .foregroundStyle(Drawing.colorButton)
                    }
                }
            }
            Spacer()
            Button {
                // action
            } label: {
                ZStack {
                    Image(Drawing.imageBuy)
                    if badgeCountBuy > 0 {
                        Text("\(badgeCountBuy)")
                            .foregroundColor(Drawing.badgeTitleColor)
                            .font(Font.system(size: 10, weight: .bold))
                            .padding(5)
                            .background(Drawing.badgeColor)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                }
            }
            
            Button {
                // action
            } label: {
                ZStack {
                    Image(Drawing.imageBell)
                    if badgeCountBell > 0 {
                        Text("\(badgeCountBell)")
                            .foregroundColor(Drawing.badgeTitleColor)
                            .font(Font.system(size: 10, weight: .bold))
                            .padding(5)
                            .background(Drawing.badgeColor)
                            .clipShape(Circle())
                            .offset(x: 10, y: -10)
                    }
                }
            }
        }
        
    }
}

#Preview {
    NavBarMenu()
}

