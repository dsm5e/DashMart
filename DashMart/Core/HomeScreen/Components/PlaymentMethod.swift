//
//  ContentView.swift
//  PlaymentMethod
//
//  Created by Ваня Науменко on 17.04.24.
//

import SwiftUI

struct PlaymentMethod: View {
    @ObservedObject private var storage = StorageService.shared
    @State private var showSheet = false
    @State private var showAlertPDF = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            Button(
                action: {
                    dismiss()
                }, label: {
                    Image(systemName: "arrow.left")
                }
            )
            Spacer()
            Text("Playment method")
                .foregroundColor(Color(hex: "#393F42"))
                .font(.system(size: 16, weight: .medium))
            Spacer()
            CartButton(
                storage: storage,
                action: {
                    dismiss()
                }
            )
        }
        .padding(.horizontal, .s20)
        SeparatorView()
        Spacer()
        VStack(alignment: .leading) {
            Spacer()
            Text("Select existing card")
                .bold()
            HStack(content: {
                Image(systemName: "creditcard")
                Text("**** **** **** 7777")
                Spacer()
                Image(systemName: "trash")

            })
            .padding()
            .frame(height: 50)
            .background(Color.clear)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#939393"), lineWidth: 1)
            }
            Spacer()
            Spacer()
        }
        .padding()
        .frame(height: 150)
        SeparatorView()
        VStack(alignment: .leading) {
            Text("Or inputnew cards")
                .bold()
            HStack {
                Button(
                    action: {
                        showSheet.toggle()
                    },
                    label: {
                        Text("Сhoose payment method")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                )
            }
            .padding()
            .frame(height: 50)
            .background(Color.clear)
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#939393"), lineWidth: 1)
            }
            Spacer()
            Spacer()
        }

        .padding()
        .navigationBarBackButtonHidden()
        .bottomSheet(isPresented: $showSheet, contentView: {
            VStack {
                HStack {
                    Button(
                        action: {
                            showSheet.toggle()
                        }, label: {
                            Spacer()
                            Image(systemName: "multiply")
                                .foregroundStyle(.black)
                        }
                    )
                }
                .padding(10)
                Image("imageOk")
                    .resizable()
                    .frame(width: 150, height: 150)
                Text("Congrats! your payment\nis successfully")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                    .foregroundColor(Color(hex: "#393F42"))
                    .multilineTextAlignment(.center)
                Spacer()
                Spacer()
                Text("Track your order or just chat directly to the\n seller. Download order summary in down below")
                    .font(.system(size: 14, design: .default))
                    .foregroundStyle(Color(hex: "#939393"))
                    .multilineTextAlignment(.center)

                Button {
//                    showAlertPDF.toggle()
                } label: {
                    Image("PDF")
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("orden_invoce")
                        .font(.system(size: 16, design: .default))
                        .foregroundStyle(Color(hex: "#939393"))
                    Spacer()
                    Spacer()
                    Image(systemName: "arrow.down.to.line.square")
                        .foregroundStyle(.black)
                }
                .padding()
                .foregroundStyle(Color(hex: "#939393"))
                .frame(width: 270, height: 50)
                .background(Color.clear)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(hex: "#939393"), lineWidth: 1)
                }
                .alert(isPresented: $showAlertPDF) {
                    Alert(title: Text("Download"), message: Text("File loaded successfully"))
                }

                Spacer()

                Button {
                    showSheet.toggle()
                } label: {
                    Text("Continue")
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 350, height: 40)
                        .foregroundStyle(.white)
                        .background(Color(hex: "#67C4A7"))
                        .cornerRadius(5)
                }
                Spacer()
            }
        })
    }
}

#Preview {
    PlaymentMethod()
}
