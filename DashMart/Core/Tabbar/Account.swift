//
//  Account.swift
//  DashMart
//
//  Created by Victor on 16.04.24.
//

import SwiftUI

struct Account: View {
    
    private let router: RouterService
    
    init(router: RouterService) {
        self.router = router
    }
    
    var body: some View {
        Button("Logout") {
            Task {
                @MainActor in
                
                if await AuthorizeService.shared.logout() {
                    router.openAuth()
                }
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(.blue)
        .clipShape(.capsule)
    }
}

#Preview {
    Account(router: RouterService())
}
