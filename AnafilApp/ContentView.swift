//
//  ContentView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
                // Título
                Image("anafilApp_main")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                
                // Logo
                Image("cmica_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 50)
                    .padding(.top, 8)
                
                // Subtítulo
                HStack(spacing: 6) {
                    Image(systemName: "doc.text")
                        .font(.title3)
                    Text("Registro")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.top, 16)
                
                Text("Ingresa los datos solicitados:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Campos de texto
                VStack(spacing: 14) {
                    TextField("Nombre(s)", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Apellidos", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                    
                    Menu {
                        Button("Español") {}
                        Button("English") {}
                    } label: {
                        HStack {
                            Text(" Selecciona idioma")
                                .foregroundColor(.gray.opacity(0.6))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.trailing, 8)
                        }
                    }
                    .frame(height: 34)
                    .frame(maxWidth: .infinity)
                    .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.2))
                        )
                    
                    TextField("Teléfono", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                    
                    TextField("Contacto de emergencia (Teléfono)", text: .constant(""))
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                
                // Navegar a la segunda pantalla (mockup geolocalización)
                NavigationLink {
                    GeolocalizacionView()
                } label: {
                    Text("Crear Cuenta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
