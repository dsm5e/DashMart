//
//  ContentView.swift
//  PlaymentMethod
//
//  Created by Ваня Науменко on 17.04.24.
//

import SwiftUI

struct PlaymentMethod: View {
    @State private var showSheet = false
    @State private var showAlertPDF = false
    var body: some View {
        Form {
            HStack(content: {
                Image(systemName: "creditcard")
                Text("**** **** **** 7777")
                Spacer()
                Image(systemName: "trash")
                        
            })
            Section(header: Text("Or inputnew cards")) {
                HStack {
                    Button(
                        action: {
                            showSheet.toggle()
                        },
                        label: {
                            Text("Сhoose payment method")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                }
            }.buttonStyle(.borderless)
        }
        .bottomSheet(isPresented: $showSheet, contentView: {
            VStack {
                            Spacer()
                            Spacer()
                            Image("imageOk")
                                .resizable()
                                .frame(width: 150, height: 150)
            
                            Text("Congrats! your payment\nis successfully")
                                .font(.system(size: 22, weight: .semibold, design: .default))
                                .foregroundColor(Color(hex: "#393F42"))
            
                            Text("Track your order or just chat directly to the seller. Download order summary in down below")
                                .font(.system(size: 14, design: .default))
                                .foregroundStyle(Color(hex: "#939393"))
                                .padding()
                Button {
                                   showAlertPDF.toggle()
                               } label: {
                                   HStack(spacing: 30) {
                                       Image("file-pdf")
                                           .resizable()
                                           .scaledToFill()
                                           .padding(20)
                                       Text("Orden invoce")
                                           .font(.system(size: 10, weight: .semibold, design: .default))
               
                                       Image(systemName: "arrow.down.to.line.square")
                                           .padding()
                                   }
                               }
                               .frame(width: 250, height: 60)
                               .foregroundStyle(Color(hex: "#939393"))
                               .buttonBorderShape(.capsule)
                               .border(Color(hex: "#939393"), width: 2)
                               .cornerRadius(5)
                               .alert(isPresented: $showAlertPDF) {
                                   Alert(title: Text("Download"), message: Text("File loaded successfully"))
                               }
               
                               Spacer()
               
                               Button {
                                   showSheet.toggle()
                               } label: {
                                   Text("Continue")
                                       .font(.system(size: 16, weight: .bold))
                               }
                               .frame(width: 350, height: 40)
                               .foregroundStyle(.white)
                               .background(Color(hex: "#67C4A7"))
                               .cornerRadius(5)
                               Spacer()
                           }
        })
    }
}

#Preview {
    PlaymentMethod()
}
