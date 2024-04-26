//
//  CartScreen.swift
//  DashMart
//
//  Created by Victor on 21.04.2024.
//

import BottomSheet
import Kingfisher
import SwiftUI

// MARK: - CartScreen

struct CartScreen: View {
    @ObservedObject private var storage = StorageService.shared
    @ObservedObject private var location = LocationService.shared
    @State private var products = [ProductEntity]()
    @State private var loading = false
    @State private var isShowingLocation = false
    @Environment(\.dismiss) private var dismiss
    var total: Double {
        var total: Double = .zero
        storage.cart.filter { storage.selectedCardIds.contains($0.key) }.forEach {
            key, value in
            
            total += (products.first(where: { $0.id == key })?.price ?? .zero) * Double(value)
        }
        return total
    }
    
    var body: some View {
        NavigationView {
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
                .padding(.horizontal, .s20)
                SeparatorView()
                HStack {
                    Text("Delivery to")
                    Spacer()
                    Text(location.country)
                    Button {
                        isShowingLocation = true
                    } label: {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 10))
                            .foregroundStyle(Color(hex: "#200E32"))
                    }
                }
                .foregroundColor(Color(hex: "393F42"))
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, .s20)
                .frame(height: .s24)
                SeparatorView()
                
                if loading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    if storage.cart.isEmpty {
                        Spacer()
                        Text("Your cart is empty")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "#393F42"))
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [.init()], spacing: .s32) {
                                ForEach(products) {
                                    product in
                                    
                                    HStack(spacing: .s8) {
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
                                                .clipShape(.rect(cornerRadius: .s4))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: .s4)
                                                        .stroke(Color(hex: "#C8C8CB"), lineWidth: 1)
                                                )
                                            }
                                        )
                                        KFImage(URL(string: product.fixedImages.first ?? ""))
                                            .placeholder {
                                                Image(.productPlaceholder)
                                                    .resizable()
                                            }
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .clipped()
                                            .scaledToFill()
                                            .clipShape(.rect(cornerRadius: .s8))
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
                                                Text(location.exchange(product.price).formatted(
                                                    .currency(code: location.currencyCode)
                                                ))
                                                .font(.system(size: 16, weight: .semibold))
                                                .foregroundColor(Color(hex: "#393F42"))
                                                Spacer()
                                                CardItemControl(id: product.id, storage: storage)
                                            }
                                            .padding(.bottom, .s4)
                                        }
                                    }
                                    .frame(height: 100)
                                }
                            }
                            .padding(.horizontal, .s20)
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
                                Text(location.exchange(total)
                                    .formatted(.currency(code: location.currencyCode))
                                )
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "#393F42"))
                            }
                            .padding(.bottom, 6)
                        }
                        .padding(.horizontal, .s20)
                        
                        NavigationLink(destination: PlaymentMethod()) {
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
//                        Button(
//                            action: {
//                                print("show payment screen")
//                            },
//                            label: {
//                                HStack {
//                                    Spacer()
//                                    Text("Select payment method")
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 14, weight: .medium))
//                                    Spacer()
//                                }
//                                .padding(.horizontal, 8)
//                                .frame(height: 45)
//                                .background(Color(hex: "#67C4A7"))
//                                .clipShape(.rect(cornerRadius: 4))
//                            }
//                        )
                        .padding(.horizontal, .s20)
                        .padding(.bottom, .s16)
                    }
                }
            }
            .bottomSheet(isPresented: $isShowingLocation, detents: [.medium()]) {
                CountrySelection()
            }
            .onChange(of: storage.cart) {
                cart in
                
                withAnimation(.linear) {
                    products.removeAll(where: { cart[$0.id] == nil })
                }
            }
            .task {
                loading = true
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
                loading = false
            }
        }
    }
}

// MARK: - CardItemControl

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

// MARK: - CardItemControlButton

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
        .frame(width: .s20, height: .s20)
        .overlay(Circle().stroke(style: .init(lineWidth: 1)).foregroundColor(.gray))
    }
}

#Preview {
    CartScreen()
}
