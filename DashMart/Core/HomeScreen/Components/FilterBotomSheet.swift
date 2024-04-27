//
//  FilterBotomSheet.swift
//  DashMart
//
//  Created by Ilya Paddubny on 27.04.2024.
//

import SwiftUI

enum SortType {
    case none
    case alphabeticalAscending
    case alphabeticalDescending
}

struct FilterBotomSheet: View {
    @Binding var isPresented: Bool
    @Binding var sortingOrder: SortType
    @Binding var priceBounds: ClosedRange<Int>
    @State var priceRange: ClosedRange<Int>
    let applyAction: (SortType, ClosedRange<Int>) -> Void
    let clearAction: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Apply filter by")
                .font(.system(size: 24))
                .bold()
                .foregroundStyle(Color(hex: "#393F42"))
                .padding()
            Text("Product name")
                .font(.system(size: 16))
                .bold()
                .foregroundStyle(Color(hex: "#393F42"))
            Picker(selection: $sortingOrder, label: Text("Sort by")) {
                Text("None").tag(SortType.none)
                Text("A-Z").tag(SortType.alphabeticalAscending)
                Text("Z-A").tag(SortType.alphabeticalDescending)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Text("Price range")
                .font(.system(size: 16))
                .bold()
                .foregroundStyle(Color(hex: "#393F42"))
            RangedSliderView(value: $priceRange, bounds: priceBounds)
                .padding(.leading, 48)
                .padding(.trailing, 48)
        }
        HStack {
            Button(
                action: {
                    clearAction()
                    isPresented = false
                }, label: {
                    Text("Clear Filter")
                        .foregroundStyle(Color(hex: "#E53935"))
                        .modifier(DashRoundedTitle(style: .gray))
                }
            )
            
            Button(
                action: {
                    applyAction(sortingOrder, priceRange)
                    isPresented = false
                }, label: {
                    Text("Apply")
                        .modifier(DashRoundedTitle())
                }
            )
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

