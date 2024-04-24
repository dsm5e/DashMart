//
//  SearchHistoryList.swift
//  DashMart
//
//  Created by Максим Самороковский on 21.04.2024.
//

import SwiftUI

struct SearchHistoryList: View {
    @ObservedObject private var storage = StorageService.shared
    
    var body: some View {
        VStack(alignment: .leading, spacing: .s8) {
            HStack {
                Text("Last search")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "#393F42"))
                
                Spacer()
                
                Button(action: {
                    Task {
                        await storage.clearSearchHistory()
                    }
                }) {
                    Text("Clear all")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#D65B5B"))
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView {
                ForEach(storage.searchHistory, id: \.self) { query in
                    Button(action: {
                        
                    }) {
                        Text(query)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                }
            }
        }
    }
}


#Preview {
    SearchHistoryList()
}
