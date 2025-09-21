//
//  GeolocalizacionView.swift
//  MediAlert
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI

struct GeolocalizacionView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("MediAlert")
                    .font(.title3).bold()
                Spacer()
                HStack(spacing: 14) {
                    NavigationLink{
                        BotiquinView()
                    } label: {
                        Image(systemName: "cross.case")
                    }
                    Image(systemName: "globe")
                }
                .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // Buscador (mock)
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                Text("Buscar lugares")
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemBackground))
            )
            .padding(.horizontal)
            
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
            Spacer()
            // Título sección
            HStack {
                Text("Hospitales más cercanos")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal)
            
            // Lista de 3 hospitales más cercanos
            VStack(spacing: 12) {
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
            
            
            Spacer()
            
            // Tab bar (mock, estático)
            HStack(spacing: 30) {
                Image(systemName: "house.fill")
                NavigationLink {
                    NotificacionesView()
                } label: {
                    Image(systemName: "bell.fill")
                }
                ZStack {
                    Circle().fill(Color(.systemBackground))
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                    Text("SOS")
                        .font(.headline)
                }
                NavigationLink{
                    GuiasView()
                } label: {
                    Image(systemName: "book.fill")
                }
                //Image(systemName: "book.fill")
                NavigationLink {
                    DatosPersonalesView()
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                }
            }
            .font(.title2)
            .padding(.vertical, 10)
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
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.secondarySystemBackground))
                Group {
                    if UIImage(named: imageName) != nil {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "building.2.crop.circle")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: 85, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 3) {
                Text(nombre).font(.subheadline).fontWeight(.semibold)
                Text(tipo).font(.footnote).foregroundColor(.secondary)
                Text(detalle).font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "location.circle")
                .font(.title3)
                .foregroundColor(.teal)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.4), radius: 3, y: 5)
        )
    }
}

#Preview {
    NavigationStack { GeolocalizacionView() }
}
