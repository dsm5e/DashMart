//
//  ManagerEditProduct.swift
//  DashMart
//
//  Created by Victor on 22.04.2024.
//

import SwiftUI
import NetworkManager

struct ManagerEditProduct: View {
    
    @ObservedObject private var state: ManagerEditState
    @ObservedObject private var location: LocationService
    @State private var title: String = ""
    @State private var price: Double = .zero
    @State private var description: String = ""
    @State private var category: CategoryEntity = .mock
    @State private var images: [ImageEntry] = [.init(text: "")]
    @State private var categories = [CategoryEntity]()
    @State private var products = [ProductEntity]()
    @State private var searchInput = ""
    @State private var product: ProductEntity?
    @State private var isAlertPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var alertMessage = ""
    
    init(state: ManagerEditState) {
        self.state = state
        self.location = .shared
    }
    
    var body: some View {
        VStack {
            VStack(spacing: .zero) {
                if state.status == .update || state.status == .delete {
                    SearchTextField(searchInput: $searchInput)
                        .padding(.horizontal, .s20)
                }
                ZStack {
                    if (state.status == .update || state.status == .delete), !searchInput.isEmpty {
                        VStack {
                            VStack {
                                ForEach(products.filter { $0.title.lowercased().contains(searchInput.lowercased()) }.prefix(6)) {
                                    product in
                                    
                                    Button(
                                        action: {
                                            self.product = product
                                            searchInput = ""
                                        },
                                        label: {
                                            Text(product.title)
                                                .font(.system(size: 12))
                                                .frame(maxWidth: .infinity)
                                                .padding(.vertical, .s4)
                                        }
                                    )
                                }
                                SeparatorView()
                            }
                            .background(Color.white)
                            Spacer()
                        }
                        .zIndex(1)
                    }
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: .s16) {
                            ManagerEditField(title: "Title", padding: .s12) {
                                TextField("", text: $title)
                            }
                            .disabled(state.status == .delete)
                            ManagerEditField(title: "Price", padding: .s12) {
                                TextField(
                                    "",
                                    value: $price,
                                    format: .currency(
                                        code: location.currencyCode
                                    )
                                )
                            }
                            .disabled(state.status == .delete)
                            ManagerEditField(
                                title: "Category",
                                padding: .s12,
                                content: {
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
                            ManagerEditField(title: "Description", padding: .s4) {
                                ZStack {
                                    TextEditor(text: $description)
                                    Text(description.isEmpty ? "S" : description).opacity(.zero)
                                }
                            }
                            .disabled(state.status == .delete)
                            ForEach($images) {
                                item in
                              
                                HStack {
                                    ManagerEditField(title: "Image", padding: .s12) {
                                        TextField("", text: item.text)
                                    }
                                    if images.count > 1 {
                                        Button(
                                            action: {
                                                images.remove(at: images.firstIndex(where: { $0.id == item.id })!)
                                            },
                                            label: {
                                                Image(systemName: "x.square")
                                            }
                                        )
                                    }
                                }
                            }
                            HStack {
                                Spacer()
                                Button(
                                    action: {
                                        images.append(.init(text: ""))
                                    },
                                    label: {
                                        Image(systemName: "plus.rectangle")
                                    }
                                )
                                Spacer()
                            }
                        }
                        .padding(.horizontal, .s20)
                    }
                    .padding(.top, .s16)
                    .zIndex(0)
                }
            }
            
            Button(
                action: {
                    if state.status == .delete {
                        if product == nil {
                            alertMessage = "Select product to delete"
                            isAlertPresented = true
                        } else {
                            isDeleteAlertPresented = true
                        }
                    } else {
                        Task {
                            await proceed()
                        }
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
            
            title = product?.title ?? ""
            price = location.exchange(product?.price ?? .zero)
            description = product?.description ?? ""
            category = product?.category ?? categories.first ?? .mock
            images = product?.fixedImages.map { ImageEntry(text: $0) } ?? [ImageEntry(text: "")]
        }
        .onChange(of: categories) {
            _ in
            
            category = categories.first!
        }
        .confirmationDialog(
            "Are you sure want to delete item?",
            isPresented: $isDeleteAlertPresented,
            actions: {
                Button(
                    "Delete this product",
                    role: .destructive) {
                        Task {
                            await proceed()
                        }
                    }
            }
        )
        .alert(
            "",
            isPresented: $isAlertPresented,
            actions: {
                Button("OK") { }
            },
            message: {
                Text(alertMessage)
                    .font(.system(size: 12))
            }
        )
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
            guard checkImages() else {
                return
            }
            switch await NetworkService.client.sendRequest(
                request: ProductRequestPost(
                    title: title,
                    price: location.revertExchange(price),
                    description: description,
                    categoryId: category.id,
                    images: images.compactMap { $0.text }
                )
            ) {
            case .success(let response):
                alertMessage = "Product \"\(response.title)\" (id: \(response.id)) was created."
                isAlertPresented = true
            case .failure(let error):
                handleError(error)
            }
        case .update:
            guard let product else {
                alertMessage = "Select product to update"
                isAlertPresented = true
                return
            }
            guard checkImages() else {
                return
            }
            switch await NetworkService.client.sendRequest(
                request: ProductRequestUpdate(
                    id: product.id,
                    title: title,
                    price: location.revertExchange(price),
                    description: description,
                    categoryId: category.id,
                    images: images.map { $0.text }
                )
            ) {
            case .success(let response):
                alertMessage = "Product \"(\(response.title)\" (id: \(response.id)) was updated"
                isAlertPresented = true
                self.product = response
            case .failure(let error):
                handleError(error)
            }
        case .delete:
            if let product {
                switch await NetworkService.client.sendRequest(request: ProductRequestDelete(id: product.id)) {
                case .success(let success):
                    alertMessage = success ? "Product \(product.id) was deleted" : "Something went wrong"
                    isAlertPresented = true
                    if success {
                        self.product = nil
                    }
                case .failure(let error):
                    handleError(error)
                }
            }
        }
        await getProductsAndCategories()
    }
    
    private func handleError(_ error: Error) {
        let errorMessage: String
        if let nError = error as? NetworkError {
            errorMessage = switch nError {
            case .apiError(let networkErrorEntity):
                networkErrorEntity?.message.joined(separator: ", ") ?? "Something went wrong"
            case .internal(let error):
                error.localizedDescription
            default:
                "Something went wrong"
            }
        } else {
            errorMessage = error.localizedDescription
        }
        alertMessage = errorMessage
        isAlertPresented = true
    }
    
    private func checkImages() -> Bool {
        if images.count > 1 {
            images.removeAll(where: { $0.text.isEmpty })
        }
        if images.isEmpty {
            images.append(.init(text: ""))
        }
        if images.count == 1, images[0].text.isEmpty {
            alertMessage = "Image url is empty"
            isAlertPresented = true
            return false
        }
        guard images.compactMap({ URL(string: $0.text) }).count == images.count else {
            alertMessage = "Some image urls are invalid"
            isAlertPresented = true
            return false
        }
        
        return true
    }
}

private struct ManagerEditField<Content: View>: View {
    
    let title: String
    let padding: CGFloat
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: 75, alignment: .leading)
                .padding(.trailing, .s16)
            
            content()
                .padding(padding)
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

private struct ImageEntry: Identifiable {
    let id = UUID()
    var text: String
}

#Preview {
    ManagerEditProduct(state: .init())
}
