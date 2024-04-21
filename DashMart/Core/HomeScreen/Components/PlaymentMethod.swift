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
        if #available(iOS 16.0, *) {
            NavigationStack {
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
                .sheet(isPresented: $showSheet, content: {
                    if #available(iOS 16.0, *) {
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
                            
                            Spacer()
                            Button {
                                showAlertPDF.toggle()
                            } label: {
                                HStack(spacing: 40) {
                                    Image("file-pdf")
                                        .resizable()
                                        .scaledToFill()
                                        .padding(25)
                                    Text("Orden_invoce")
                                        .font(.system(size: 10, weight: .semibold, design: .default))
                                    
                                    Image(systemName: "arrow.down.to.line.square")
                                }
                            }
                            .frame(width: 250, height: 40)
                            .foregroundStyle(.gray)
                            .border(Color.black)
                            .alert(isPresented: $showAlertPDF) {
                                Alert(title: Text("Download"), message: Text("File loaded successfully"))
                            }
                            Spacer()
                            if #available(iOS 17.0, *) {
                                Button {
                                    showSheet.toggle()
                                } label: {
                                    Text("Continue")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .frame(width: 350, height: 40)
                                .foregroundStyle(.white)
                                .background(Color(hex: "#67C4A7"))
                                .clipShape(.buttonBorder)
                            } else {
                                // Fallback on earlier versions
                            }
                            Spacer()
                        }
                        .presentationDetents([.fraction(0.7)])
                    } else {
                        // Fallback on earlier versions
                    }
                })
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    PlaymentMethod()
}
