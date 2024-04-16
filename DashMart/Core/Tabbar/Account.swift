//
//  Account.swift
//  DashMart
//
//  Created by Ваня Науменко on 15.04.24.
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
    }
}

#Preview {
    Account(router: RouterService())
}
