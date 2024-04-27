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
                    .font(.system(size: 16))
                    .foregroundStyle(Color(hex: "#393F42"))
                
                Spacer()
                
                Button(action: {
                    Task {
                        storage.clearSearchHistory()
                    }
                }) {
                    Text("Clear all")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#D65B5B"))
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView {
                ForEach(storage.searchHistory.indices, id: \.self) { index in
                    let query = storage.searchHistory[index]
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(Color(hex: "#939393"))
                        Text(query)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "#393F42"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                        Spacer()
                        Button(action: {
                            Task {
                                storage.removeSearchHistory(at: index)
                            }
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color(hex: "#939393"))
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SearchHistoryList()
}

