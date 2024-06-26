//
//  TitleDetail.swift
//  DashMart
//
//  Created by Максим Самороковский on 17.04.2024.
//

import SwiftUI

struct TitleDetail: View {
    @State private var badgeCountBuy = 2
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var storage = StorageService.shared
    var cartButtonAction: (() -> Void)?
    
    var body: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundStyle(Color(hex: "#393F42"))
                    
            }
            Spacer()
            Text("Details product")
                .font(.system(size: .s16))
                .foregroundStyle(Color(hex: "#393F42"))
            
            Spacer()
            CartButton(
                storage: storage,
                action: cartButtonAction
            )
        }
    }
}

#Preview {
    TitleDetail()
}
