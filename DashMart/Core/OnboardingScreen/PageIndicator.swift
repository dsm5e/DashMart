//
//  PageIndicator.swift
//  HomeChaleng
//
//  Created by Ваня Науменко on 15.04.24.
//

import SwiftUI

struct PageIndicator: View {
    let numberOfPages: Int
    var currentIndex: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<numberOfPages) { index in
                Rectangle()
                    .fill(index == currentIndex ? Color.black : Color.gray)
                    .frame(width: index == currentIndex ? 30 : 10, height: 8)
                    .cornerRadius(20)
                    .animation(.default)
            }
        }
    }
}

#Preview {
    PageIndicator(numberOfPages: 3, currentIndex: 0)
}
