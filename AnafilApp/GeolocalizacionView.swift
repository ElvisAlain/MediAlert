//
//  GeolocalizacionView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI

struct GeolocalizacionView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("AnafilApp")
                    .font(.title3).bold()
                Spacer()
                HStack(spacing: 14) {
                    NotificacionesBellView()
                    Image(systemName: "globe")
                }
                .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Spacer().frame(height: 16)
            
            // Mapa
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    Group {
                        if UIImage(named: "mapa") != nil {
                            Image("mapa")
                                .resizable()
                                .scaledToFill()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            Text("Mapa (placeholder)")
                                .foregroundColor(.secondary)
                        }
                    }
                )
                .frame(height: 180)
                .padding(.horizontal)
            Spacer().frame(height: 24)
            // Título sección
            HStack {
                Text("Hospitales más cercanos")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            Spacer().frame(height: 24)
            
            // Lista de 3 hospitales más cercanos
            VStack(spacing: 20) {
                HospitalRowMock(
                    imageName: "hospital1",
                    nombre: "Hospital Angelopolitano",
                    tipo: "Hospital privado",
                    detalle: "Abierto las 24 horas\n222 246 5688"
                )

                HospitalRowMock(
                    imageName: "hospital2",
                    nombre: "Hospital Puebla",
                    tipo: "Hospital privado",
                    detalle: "Abierto las 24 horas\n222 594 0600"
                )
                HospitalRowMock(
                    imageName: "hospital3",
                    nombre: "Hospital General de Cholula",
                    tipo: "Hospital general",
                    detalle: "Abierto las 24 horas\n222 214 4300"
                )
            }
            .padding(.horizontal)
            Spacer(minLength: 0)
            // Tab bar (mock, estático)
            MenuInferior(activeTab: "home")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct HospitalRowMock: View {
    let imageName: String
    let nombre: String
    let tipo: String
    let detalle: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(Color(.secondarySystemBackground))
                Group {
                    if UIImage(named: imageName) != nil {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(85.0/70.0, contentMode: .fill)
                            .frame(width: 85, height: 70)
                            .clipped()
                        
                    } else {
                        Image(systemName: "building.2.crop.circle")
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .frame(width: 85, height: 70)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                    }
                }
            }
            .frame(width: 85, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 9))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nombre).font(.subheadline).fontWeight(.semibold)
                Text(tipo).font(.footnote).foregroundColor(.secondary)
                Text(detalle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            Image(systemName: "location.circle")
                .font(.title3)
                .foregroundColor(.teal)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 9)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.4), radius: 3, y: 5)
        )
    }
}

#Preview {
    NavigationStack { GeolocalizacionView() }
}
