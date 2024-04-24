//
//  Modifiers.swift
//  DashMart
//
//  Created by Victor on 23.04.2024.
//

import SwiftUI

struct NavigationViewModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let title: String
    
    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading,
                    content: {
                        Button(
                            action: {
                                dismiss()
                            },
                            label: {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.black)
                            }
                        )
                    }
                )
            }
    }
}

struct DashRoundedTitle: ViewModifier {
    
    enum Style {
        case `default`
        case red
        case gray
        
        var textColor: Color {
            switch self {
            case .gray:
                Color(hex: "#393F42")
            default:
                Color.white
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .default:
                Color(hex: "#67C4A7")
            case .red:
                Color(hex: "#E53935")
            case .gray:
                Color(hex: "#F0F2F1")
            }
        }
        
        var borderColor: Color? {
            switch self {
            case .gray:
                Color(hex: "#D9D9D9")
            default:
                nil
            }
        }
    }
    
    let style: Style
    
    init(style: Style = .default) {
        self.style = style
    }
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: .s16))
            .foregroundColor(style.textColor)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.s16)
            .background(style.backgroundColor)
            .clipShape(.rect(cornerRadius: .s4))
            .overlay(
                RoundedRectangle(cornerRadius: .s4)
                    .stroke(style.borderColor ?? style.backgroundColor, lineWidth: 1)
            )
    }
}
