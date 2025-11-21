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
            if activeTab == "home" {
                VStack(spacing: 4) {
                    Image(systemName: "house.fill")
                        .font(.title2)
                }
                .foregroundStyle(Color.cmicaBlue)
                .frame(width: 50)
            } else {
                NavigationLink { GeolocalizacionView() } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "house.fill")
                            .font(.title2)
                    }
                    .foregroundStyle(.gray)
                    .frame(width: 50)
                }
            }
            
            Spacer()
            
            // 2. Botiquín
            if activeTab == "botiquin" {
                VStack(spacing: 4) {
                    Image(systemName: "cross.case.fill")
                        .font(.title2)
                }
                .foregroundStyle(Color.cmicaBlue)
                .frame(width: 50)
            } else {
                NavigationLink { BotiquinView() } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "cross.case.fill")
                            .font(.title2)
                    }
                    .foregroundStyle(.gray)
                    .frame(width: 50)
                }
            }
            
            Spacer()
            
            // 3. SOS
            SOSDragButton()
                .padding(.bottom, 10)
            
            Spacer()
            
            // 4. Guías
            if activeTab == "guias" {
                VStack(spacing: 4) {
                    Image(systemName: "book.fill")
                        .font(.title2)
                }
                .foregroundStyle(Color.cmicaBlue)
                .frame(width: 50)
            } else {
                NavigationLink { GuiasView() } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "book.fill")
                            .font(.title2)
                    }
                    .foregroundStyle(.gray)
                    .frame(width: 50)
                }
            }
            
            Spacer()
            
            // 5. Perfil
            if activeTab == "perfil" {
                VStack(spacing: 4) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.title2)
                }
                .foregroundStyle(Color.cmicaBlue)
                .frame(width: 50)
            } else {
                NavigationLink { DatosPersonalesView() } label: {
                    VStack(spacing: 4) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.title2)
                    }
                    .foregroundStyle(.gray)
                    .frame(width: 50)
                }
            }
            Spacer()
        }
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 2, y: -1)
    }
}
