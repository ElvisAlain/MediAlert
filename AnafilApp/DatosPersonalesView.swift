//
//  DatosPersonalesView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 17/09/25.
//

import SwiftUI

struct DatosPersonalesView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack(spacing: 16) {

            HStack {
                Label("Datos Personales", systemImage: "info.circle")
                    .font(.title3.weight(.semibold))
                Spacer()
                HStack(spacing: 14) {
                    NavigationLink{
                        BotiquinView()
                    } label: {
                        Image(systemName: "cross.case")
                    }
                    Image(systemName: userData.idiomaSeleccionado == "Español" ? "globe": "globe.fill")
                }
                .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color(.secondarySystemBackground))
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray.opacity(0.7))
                        .padding(6)
                }
                .frame(width: 56, height: 56)

                Text(userData.nombre)
                    .font(.title3.weight(.semibold))
                Image(systemName: "pencil")
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal)

            // Lista de chips
            ScrollView {
                VStack(spacing: 14) {
                    ChipRow(titulo: "Nombre:", valor: userData.nombre, editable: true)
                    ChipRow(titulo: "Apellidos:", valor: userData.apellidos, editable: true)
                    ChipRow(titulo: "Teléfono:", valor: userData.telefono, editable: true)
                    ChipRow(titulo: "Contacto Emergencias:", valor: userData.contactoEmergencia, editable: true)
                    ChipRow(titulo: "Dirección:", valor: "Avenida José María", editable: true)
                    ChipRow(titulo: "Sexo:", valor: "Mujer", editable: true)
                    ChipRow(titulo: "Peso:", valor: "60 Kg", editable: true)
                    ChipRow(titulo: "Edad:", valor: "30 años", editable: true)
                    ChipRow(titulo: "Tipo de sangre:", valor: "O+", editable: true)
                    ChipRow(titulo: "Diagnóstico:", valor: "Asma", editable: true)
                    ChipRow(titulo: "Alergias:", valor: "Polvo, polen, ...", editable: true)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }

            // Tab bar (mock, estático)
            HStack(spacing: 30) {
                NavigationLink{
                    GeolocalizacionView()
                } label: {
                    Image(systemName: "house.fill")
                }
                NavigationLink{
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
                NavigationLink {GuiasView()} label: {Image(systemName: "book.fill")}
                // Image(systemName: "book.fill")
                Image(systemName: "person.crop.circle.fill")
            }
            .font(.title2)
            .padding(.vertical, 10)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// Estructura Chip
struct ChipRow: View {
    let titulo: String
    let valor: String
    var editable: Bool = false

    var body: some View {
        HStack {
            HStack(spacing: 2) {
                Text(titulo)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.blue.opacity(0.9))
                Text(valor)
            }
            Spacer()
            if editable {
                Image(systemName: "pencil")
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(.systemGray5))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }
}

#Preview {
    NavigationStack { DatosPersonalesView() }
}
