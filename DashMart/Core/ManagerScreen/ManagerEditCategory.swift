//
//  ManagerEditCategory.swift
//  DashMart
//
//  Created by Victor on 23.04.2024.
//

import SwiftUI
import NetworkManager

struct ManagerEditCategory: View {
    
    @ObservedObject private var state: ManagerEditState
    @State private var title: String = ""
    @State private var image: String = ""
    @State private var searchInput = ""
    @State private var category: CategoryEntity? = nil
    @State private var categories = [CategoryEntity]()
    @State private var isAlertPresented = false
    @State private var isDeleteAlertPresented = false
    @State private var alertMessage = ""
    
    init(state: ManagerEditState) {
        self.state = state
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
                                ForEach(categories.filter { $0.name.lowercased().contains(searchInput.lowercased()) }.prefix(6)) {
                                    category in
                                    
                                    Button(
                                        action: {
                                            self.category = category
                                            searchInput = ""
                                        },
                                        label: {
                                            Text(category.name)
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
                            ManagerEditField(title: "Name", padding: .s12) {
                                TextField("", text: $title)
                            }
                            .disabled(state.status == .delete)
                            ManagerEditField(title: "Image", padding: .s12) {
                                TextField("", text: $image)
                            }
                            .disabled(state.status == .delete)
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
                        if category == nil {
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
            await getCategories()
        }
        .onChange(of: category) {
            category in
            
            title = category?.name ?? ""
            image = category?.image ?? ""
        }
        .confirmationDialog(
            "Are you sure want to delete category?",
            isPresented: $isDeleteAlertPresented,
            actions: {
                Button(
                    "Delete this category",
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

extension ManagerEditCategory {
    private func getCategories() async {
        switch await NetworkService.client.sendRequest(request: CategoriesRequest()) {
        case .success(let result):
            categories = result
        case .failure:
            break
        }
    }
    
    private func proceed() async {
        switch state.status {
        case .add:
            guard checkImage() else {
                return
            }
            switch await NetworkService.client.sendRequest(
                request: CategoryRequestPost(
                    name: title,
                    image: image
                )
            ) {
            case .success(let response):
                alertMessage = "Category \"\(response.name)\" (id: \(response.id)) was created."
                isAlertPresented = true
            case .failure(let error):
                handleError(error)
            }
        case .update:
            guard let category else {
                alertMessage = "Select category to update"
                isAlertPresented = true
                return
            }
            guard checkImage() else {
                return
            }
            switch await NetworkService.client.sendRequest(
                request: CategoryRequestUpdate(
                    id: category.id,
                    name: title,
                    image: image
                )
            ) {
            case .success(let response):
                alertMessage = "Category \"(\(response.name)\" (id: \(response.id)) was updated"
                isAlertPresented = true
                self.category = response
            case .failure(let error):
                handleError(error)
            }
        case .delete:
            if let category {
                switch await NetworkService.client.sendRequest(request: CategoryRequestDelete(id: category.id)) {
                case .success(let success):
                    alertMessage = success ? "Category \(category.id) was deleted" : "Something went wrong"
                    isAlertPresented = true
                    if success {
                        self.category = nil
                    }
                case .failure(let error):
                    handleError(error)
                }
            }
        }
        await getCategories()
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
    
    private func checkImage() -> Bool {
        if image.isEmpty {
            alertMessage = "Image url is empty"
            isAlertPresented = true
            return false
        }
        guard URL(string: image) != nil else {
            alertMessage = "Image url is invalid"
            isAlertPresented = true
            return false
        }
        
        return true
    }
}
