//
//  ManagerEditScreen.swift
//  DashMart
//
//  Created by Victor on 22.04.2024.
//

import SwiftUI

final class ManagerEditState: ObservableObject {
    enum Status: String {
        case add, update, delete
    }
    
    @Published var status: Status = .add
}

struct ManagerEditScreen<ContentView>: View where ContentView: View {
    
    let state: ManagerEditState
    let builder: () -> ContentView
    
    var body: some View {
        VStack(spacing: .s16) {
            HStack {
                Button(
                    action: { state.status = .add },
                    label: {
                        Text("Add")
                            .modifier(DashRoundedTitle())
                    }
                )
                
                Spacer()
                
                Button(
                    action: { state.status = .update },
                    label: {
                        Text("Update")
                            .modifier(DashRoundedTitle())
                    }
                )
                
                Spacer()
                
                Button(
                    action: { state.status = .delete },
                    label: {
                        Text("Delete")
                            .modifier(DashRoundedTitle())
                    }
                )
            }
            .padding(.horizontal, .s20)
            builder()
            Spacer()
        }
    }
}
