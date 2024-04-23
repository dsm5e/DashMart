//
//  ManagerScreen.swift
//  DashMart
//
//  Created by Victor on 22.04.2024.
//

import SwiftUI

struct ManagerScreen: View {
    
    private let managerService = ManagerService.shared
    private let state: ManagerEditState = .init()
    
    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                SeparatorView()
                VStack(spacing: .s24) {
                    Spacer()
                    NavigationLink(
                        destination: {
                            DashScreen(title: "Product panel") {
                                ManagerEditScreen<ManagerEditProduct>(state: state) {
                                    .init(state: state)
                                }
                            }
                        },
                        label: {
                            Text("Product")
                                .modifier(DashRoundedTitle())
                        }
                    )
                    NavigationLink(
                        destination: {
                            DashScreen(title: "Category panel") {
                                ManagerEditScreen<ManagerEditCategory>(state: state) {
                                    .init(state: state)
                                }
                            }
                        },
                        label: {
                            Text("Category")
                                .modifier(DashRoundedTitle())
                        }
                    )
                    Spacer()
                }
                .padding(.horizontal, .s20)
                .padding(.vertical, .s24)
            }
            .navigationTitle("Manager Screen")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ManagerScreen()
}
