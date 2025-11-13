//
//  MenuInferior.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 13/11/25.
//

import SwiftUI

struct MenuInferior: View {
    var activeTab: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            // 1. Home
            Spacer()
            NavigationLink { GeolocalizacionView() } label: {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.title2)
                }
                .foregroundStyle(activeTab == "home" ? .blue : .gray)
                .frame(width: 50) // Zona de toque
            }
            .disabled(activeTab == "home")
            
            Spacer()
            
            // 2. Botiquín
            NavigationLink { BotiquinView() } label: {
                VStack(spacing: 4) {
                    Image(systemName: "cross.case.fill")
                        .font(.title2)
                }
                .foregroundStyle(activeTab == "botiquin" ? .blue : .gray)
                .frame(width: 50)
            }
            .disabled(activeTab == "botiquin")
            
            Spacer()
            
            // 3. SOS
            SOSDragButton()
                .padding(.bottom, 10)
            
            Spacer()
            
            // 4. Guías
            NavigationLink { GuiasView() } label: {
                VStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.title2)
                }
                .foregroundStyle(activeTab == "guias" ? .blue : .gray)
                .frame(width: 50)
            }
            .disabled(activeTab == "guias")
            
            Spacer()
            
            // 5. Perfil
            NavigationLink { DatosPersonalesView() } label: {
                VStack(spacing: 4) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                }
                .foregroundStyle(activeTab == "perfil" ? .blue : .gray)
                .frame(width: 50)
            }
            .disabled(activeTab == "perfil")
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 2, y: -1) // Sombra sutil arriba
    }
}
