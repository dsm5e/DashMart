//
//  ManagerEditProduct.swift
//  DashMart
//
//  Created by Victor on 22.04.2024.
//

import SwiftUI
import BottomSheet

struct ManagerEditProduct: View {
    
    @ObservedObject private var state: ManagerEditState
    @ObservedObject private var location: LocationService
    @State private var title: String = ""
    @State private var price: Double = .zero
    @State private var description: String = ""
    @State private var category: CategoryEntity = .mock
    @State private var categories = [CategoryEntity]()
    @State private var products = [ProductEntity]()
    @State private var isCategoriesPickerPresented = false
    @State private var searchInput = ""
    @State private var product: ProductEntity?
    
    init(state: ManagerEditState) {
        self.state = state
        self.location = .shared
    }
    
    var body: some View {
        VStack {
            if state.status == .update || state.status == .delete {
                ZStack {
                    VStack(spacing: .zero) {
                        SearchTextField(searchInput: $searchInput)
                        ForEach(products.filter { $0.title.contains(searchInput) }.prefix(6)) {
                            product in
                            
                            Button(
                                action: {
                                    self.product = product
                                    searchInput = ""
                                },
                                label: {
                                    Text(product.title)
                                        .font(.system(size: 12))
                                        .padding(.vertical, .s4)
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, .s20)
            }
            ScrollView(showsIndicators: false) {
                VStack(spacing: .s16) {
                    ManagerEditField(title: "Title") {
                        TextField("", text: $title)
                    }
                    ManagerEditField(title: "Price") {
                        TextField(
                            "",
                            value: $price,
                            format: .currency(
                                code: location.currencyCode
                            )
                        )
                    }
                    ManagerEditField(
                        title: "Category",
                        content: {
//                            Button(
//                                action: {
//                                    isCategoriesPickerPresented = true
//                                },
//                                label: {
//                                    HStack {
//                                        Text(category.name)
//                                        Spacer()
//                                        Image(systemName: "chevron.down")
//                                    }
//                                    .foregroundColor(.black)
//                                }
//                            )
                            Picker("", selection: $category) {
                                ForEach(categories) {
                                    Text($0.name)
                                        .tag($0)
                                }
                            }
                            .tint(Color.black)
                            .frame(maxWidth: .infinity, maxHeight: 15, alignment: .leading)
                        }
                    )
                    ManagerEditField(title: "Description") {
                        TextField("", text: $description)
                    }
                }
                .padding(.horizontal, .s20)
            }
            Button(
                action: {
                    Task {
                        await proceed()
                    }
                },
                label: {
                    Text(state.status.rawValue.capitalized)
                        .modifier(
                            DashRoundedTitle(
                                style: state.status == .delete ? .red : .default
                            )
                        )
                }
            )
            .padding(.horizontal, .s20)
        }
        .task {
            await getProductsAndCategories()
        }
        .onChange(of: product) {
            product in
            
            if let product {
                title = product.title
                price = location.exchange(product.price)
                description = product.description
                category = product.category
            }
        }
        .onChange(of: categories) {
            _ in
            
            category = categories.first!
        }
        .bottomSheet(
            isPresented: $isCategoriesPickerPresented) {
                CategoriesPicker(selection: $category, categories: categories)
            }
    }
}

extension ManagerEditProduct {
    private func getProductsAndCategories() async {
        async let productsRequest = NetworkService.client.sendRequest(request: ProductsRequest())
        async let categoriesRequest = NetworkService.client.sendRequest(request: CategoriesRequest())
        
        let results = await (productsRequest, categoriesRequest)
        switch results.0 {
        case .success(let result):
            products = result
        case .failure:
            break
        }
        
        switch results.1 {
        case .success(let result):
            categories = result
        case .failure:
            break
        }
    }
    
    private func proceed() async {
        switch state.status {
        case .add:
            await NetworkService.client.sendRequest(
                request: ProductRequestPost(
                    title: title,
                    price: location.exchange(price),
                    description: description,
                    categoryId: 1,
                    images: ["https://i.imgur.com/bBEWTKx.jpeg", "https://i.imgur.com/bBEWTKx.jpeg"]
                )
            )
        case .update:
            guard let product else {
                return
            }
            let result = await NetworkService.client.sendRequest(
                request: ProductRequestUpdate(
                    id: product.id,
                    title: title,
                    price: location.exchange(price),
                    description: description,
                    categoryId: category.id,
                    images: ["https://i.imgur.com/bBEWTKx.jpeg"]
                )
            )
            print(result)
        default:
            break
        }
    }
}

private struct CategoriesPicker: View {
    @Binding var selection: CategoryEntity
    let categories: [CategoryEntity]
    
    var body: some View {
        VStack {
            Picker("", selection: $selection) {
                ForEach(categories) {
                    Text($0.name)
                        .tag($0)
                }
            }
            .pickerStyle(.wheel)
        }
        .onChange(of: selection) {
            print($0.name)
        }
    }
}

private struct ManagerEditField<Content: View>: View {
    
    let title: String
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: 75, alignment: .leading)
                .padding(.trailing, .s16)
            
            content()
                .padding(.s12)
                .modifier(StrokeModifier())
        }
        .font(.system(size: 13, weight: .semibold))
    }
}

private struct StrokeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: .s4)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(hex: "#F0F2F1"))
            )
    }
}

#Preview {
    ManagerEditProduct(state: .init())
}
