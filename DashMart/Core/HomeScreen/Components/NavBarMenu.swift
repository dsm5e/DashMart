//
//  NavBarMenu.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
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
        static let colorButton = Color(hex: "#200E32")
        static let titleButtonFontSize: CGFloat = 7
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
            
            CustomIconButton(imageName: Drawing.imageBuy, badgeCount: 2) {
                // action
            }
            
            CustomIconButton(imageName: Drawing.imageBell, badgeCount: 0) {
                // action
            }
        }
        
    }
}

#Preview {
    NavBarMenu()
}
