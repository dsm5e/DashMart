//
//  DashScreen.swift
//  DashMart
//
//  Created by Victor on 23.04.2024.
//

import SwiftUI

struct DashScreen<Content>: View where Content: View {
    
    let title: String
    let builder: (() -> Content)
    
    init(title: String, _ builder: @escaping (() -> Content)) {
        self.title = title
        self.builder = builder
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            SeparatorView()
            Spacer()
            builder()
            Spacer()
            SeparatorView()
        }
        .dashNavBar(title: title)
    }
}

