//
//  View+Extension.swift
//  DashMart
//
//  Created by Victor on 16.04.2024.
//

import SwiftUI

extension View {
    func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
