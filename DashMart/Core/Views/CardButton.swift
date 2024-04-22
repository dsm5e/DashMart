//
//  CarButton.swift
//  DashMart
//
//  Created by Victor on 21.04.2024.
//

import SwiftUI

struct CartButton: View {
    @ObservedObject var storage: StorageService
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(
            action: {
                action?()
            }, label: {
                ZStack {
                    Image(.buy)
                        .renderingMode(.template)
                        .foregroundColor(Color(hex: "#393F42"))
                    if storage.cart.count > 0 {
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(storage.cartCount)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 8, weight: .bold))
                                    .frame(width: 12, height: 12)
                                    .background(Color(hex: "#D65B5B"))
                                    .clipShape(.rect(cornerRadius: 6))
                            }
                            Spacer()
                        }
                    }
                }
                .frame(width: 28, height: 28)
            }
        )
    }
}
