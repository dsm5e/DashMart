//
//  HomeScreen.swift
//  DashMart
//
//  Created by dsm 5e on 14.04.2024.
//

import SwiftUI

struct HomeScreen: View {
    @State private var searchText: String = ""
    var body: some View {
        VStack {
            NavBarMenu()
                .padding(6)
            SearchBar(text: $searchText)
        }
        .padding()
        Spacer()
        
//        HStack {
//            Categories()
//        }
//        
//        VStack {
//            TitleFilters()
//        }
//        .padding()
//        ScrollView {
//            ProductList()
//        }
    }
}

#Preview {
    HomeScreen()
}
