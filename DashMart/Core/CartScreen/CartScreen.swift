//
//  CartScreen.swift
//  DashMart
//
//  Created by Victor on 21.04.2024.
//

import SwiftUI
import Kingfisher

struct CartScreen: View {
    
    @ObservedObject private var storage = StorageService.shared
    @State private var products = [ProductEntity]()
    @Environment(\.dismiss) private var dismiss
    var total: Double {
        var total: Double = .zero
        storage.cart.filter { storage.selectedCardIds.contains($0.key) }.forEach {
            (key, value) in
            
            total += (products.first(where: { $0.id == key })?.price ?? .zero) * Double(value)
        }
        return total
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(
                    action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "arrow.left")
                    }
                )
                Spacer()
                Text("Your Cart")
                    .foregroundColor(Color(hex: "#393F42"))
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                CartButton(storage: storage, action: nil)
                    .disabled(true)
            }
            .padding(.horizontal, 20)
            SeparatorView()
            HStack {
                Text("Delivery to")
                Spacer()
                Text("Salatiga City, Central Java")
            }
            .foregroundColor(Color(hex: "393F42"))
            .font(.system(size: 14, weight: .medium))
            .padding(.horizontal, 20)
            .frame(height: 24)
            SeparatorView()
            
            if storage.cart.isEmpty {
                Spacer()
                Text("Your cart is empty")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "#393F42"))
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [.init()], spacing: 30) {
                        ForEach(products) {
                            product in
                            
                            HStack(spacing: 8) {
                                Button(
                                    action: {
                                        if storage.selectedCardIds.contains(product.id) {
                                            storage.removeSelectedCardId(product.id)
                                        } else {
                                            storage.addSelectedCardId(product.id)
                                        }
                                    },
                                    label: {
                                        ZStack {
                                            Image(systemName: "checkmark")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.white)
                                                .padding(5)
                                        }
                                        .background(
                                            storage.selectedCardIds.contains(product.id) ? Color(hex: "#67C4A7") : Color.clear
                                        )
                                        .frame(width: 25, height: 25)
                                        .clipShape(.rect(cornerRadius: 4))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(Color(hex: "#C8C8CB"), lineWidth: 1)
                                        )
                                    }
                                )
                                KFImage(URL(string: product.images.first ?? ""))
                                    .placeholder {
                                        Image(.productPlaceholder)
                                            .resizable()
                                    }
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .scaledToFill()
                                    .clipShape(.rect(cornerRadius: 8))
                                    .contentShape(Rectangle())
                                VStack {
                                    Text(product.title)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(Color(hex: "#393F42"))
                                        .lineLimit(2)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.top, 4)
                                    Spacer()
                                    HStack {
                                        Text(product.price.formatted(.currency(code: "USD")))
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(Color(hex: "#393F42"))
                                        Spacer()
                                        CardItemControl(id: product.id, storage: storage)
                                    }
                                    .padding(.bottom, 4)
                                }
                            }
                            .frame(height: 100)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                SeparatorView()
                
                Group {
                    HStack {
                        Text("Order Summary")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#393F42"))
                        Spacer()
                    }
                    .padding(.vertical, 6)
                    HStack {
                        Text("Totals")
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#393F42"))
                        Spacer()
                        Text(total.formatted(.currency(code: "USD")))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(hex: "#393F42"))
                    }
                    .padding(.bottom, 6)
                }
                .padding(.horizontal, 20)
                
                Button(
                    action: {
                        print("show payment screen")
                    },
                    label: {
                        HStack {
                            Spacer()
                            Text("Select payment method")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .medium))
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .frame(height: 45)
                        .background(Color(hex: "#67C4A7"))
                        .clipShape(.rect(cornerRadius: 4))
                    }
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .onChange(of: storage.cart) {
            cart in
            
            withAnimation(.linear) {
                products.removeAll(where: { cart[$0.id] == nil })
            }
        }
        .task {
            let result = await withTaskGroup(of: ProductEntity?.self, returning: [ProductEntity].self) { group in
                for id in storage.cart.keys {
                    group.addTask {
                        let response = await NetworkService.client.sendRequest(request: ProductRequestGet(id: id))
                        return try? response.get()
                    }
                }
                var products = [ProductEntity]()
                for await result in group {
                    if let result {
                        products.append(result)
                    }
                }
                return products.sorted { $0.title < $1.title }
            }
            products = result
            
            // remove deleted items from cart
            let productIds = Set(products.map { $0.id })
            for id in storage.cart.keys {
                if !productIds.contains(id) {
                    storage.totalRemoveFromCart(id)
                }
            }
        }
    }
}

struct CardItemControl: View {
    let id: Int
    @ObservedObject var storage: StorageService
    
    var body: some View {
        HStack {
            CardItemControlButton(
                image: Image(systemName: "minus"),
                action: {
                    storage.removeFromCart(id)
                }
            )
            
            Text("\(storage.cart[id] ?? 1)")
                .foregroundColor(Color(hex: "#393F42"))
            
            CardItemControlButton(
                image: Image(systemName: "plus"),
                action: {
                    storage.addToCart(id)
                }
            )
            
            CardItemControlButton(
                image: Image(systemName: "trash"),
                action: {
                    storage.totalRemoveFromCart(id)
                }
            )
        }
    }
}

private struct CardItemControlButton: View {
    
    var image: Image
    var action: (() -> Void)?
    
    var body: some View {
        Button(
            action: {
                action?()
            },
            label: {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.gray)
            }
        )
        .frame(width: 20, height: 20)
        .overlay(Circle().stroke(style: .init(lineWidth: 1)).foregroundColor(.gray))
    }
}

#Preview {
    CartScreen()
}
