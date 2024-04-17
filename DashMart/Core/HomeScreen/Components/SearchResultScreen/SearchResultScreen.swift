//
//  SearchResultScreen.swift
//  DashMart
//
//  Created by Максим Самороковский on 16.04.2024.
//

import SwiftUI

struct SearchResultScreen: View {
    @Binding var searchTextResult: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(Color(hex: "#393F42"))
                        
                }
                
                SearchBar(text: $searchTextResult, onCommit: {})
                CustomIconButton(imageName: "buy", badgeCount: 2) {
                    // action
                }
            }
            .padding()
            
            Divider()
            

            TitleFilters(text: "Search result for \(searchTextResult)")
                .padding(.horizontal)
                .padding(.top)
            ScrollView {
                ProductList()
            }
            Spacer()
        }
    }
}

#Preview {
    let searchTextBinding = Binding.constant("Earphone")
           return SearchResultScreen(searchTextResult: searchTextBinding)
}
