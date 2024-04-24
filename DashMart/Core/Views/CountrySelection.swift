//
//  CountrySelection.swift
//  DashMart
//
//  Created by Victor on 22.04.2024.
//

import SwiftUI

struct CountrySelection: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var country: String
    private let location = LocationService.shared
    
    init() {
        _country = State(initialValue: location.country)
    }
    
    var body: some View {
        VStack {
            Spacer()
            Picker(
                "Select your country",
                selection: $country,
                content: {
                    ForEach(ContriesConstants.countries, id: \.self) {
                        Text($0)
                    }
                }
            )
            .pickerStyle(.inline)
            Spacer()
            
            Button(
                action: {
                    location.setCountryManual(country)
                    dismiss()
                },
                label: {
                    HStack {
                        Spacer()
                        Text("Save")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 45)
                    .background(Color(hex: "#67C4A7"))
                    .clipShape(.rect(cornerRadius: 4))
                }
            )
            .padding(.horizontal, .s20)
            .padding(.bottom, 8)
            
            Button(
                action: {
                    location.setAutoLocation()
                    dismiss()
                },
                label: {
                    HStack {
                        Spacer()
                        Text("AutoLocation")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .frame(height: 45)
                    .background(Color(hex: "#67C4A7"))
                    .clipShape(.rect(cornerRadius: 4))
                }
            )
            .padding(.horizontal, .s20)
            .padding(.bottom, .s24)

        }
    }
}
