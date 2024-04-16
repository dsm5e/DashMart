//
//  HomeScreen.swift
//  DashMart
//
//  Created by dsm 5e on 14.04.2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var searchText: String = ""
    @State private var isShowingSearchResults = false
    
    var body: some View {
        VStack {
            VStack {
                NavBarMenu()
                    .padding(6)
                SearchBar(text: $searchText) {
                    isShowingSearchResults = true
                }
                
                Categories()
                
                TitleFilters(text: "Products")
            }
            .padding()
            .fullScreenCover(isPresented: $isShowingSearchResults) {
                SearchResultScreen(searchTextResult: $searchText)
            }
            
            VStack {
                ScrollView {
                    ProductList()
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
