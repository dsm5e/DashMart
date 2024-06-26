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
    @ObservedObject var storage: StorageService
    @ObservedObject var location: LocationService
    var cartButtonAction: (() -> Void)?
    var locationAction: (() -> Void)?
    
    private enum Drawing {
        static let titleSecondColor = Color(hex: "#C8C8CB")
        static let titleBaseColor = Color(hex: "#393F42")
        static let titleSecondFontSize: CGFloat = 10
        static let titleBaseFontSize: CGFloat = 12
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
                    Text(location.country)
                        .font(.system(size: Drawing.titleBaseFontSize))
                        .foregroundStyle(Drawing.titleBaseColor)
                    
                    Button {
                        locationAction?()
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: Drawing.titleButtonFontSize))
                            .foregroundStyle(Drawing.colorButton)
                    }
                }
            }
            Spacer()
            
            CartButton(
                storage: storage,
                action: cartButtonAction
            )
                .padding(.trailing, 12)
            Button(
                action: {
                    print("notification")
                },
                label: {
                    Image(.notification)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(Color(hex: "#393F42"))
                }
            )
        }
        
    }
}

#Preview {
    NavBarMenu(storage: .shared, location: .shared)
}
