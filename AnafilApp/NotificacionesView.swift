//
//  NotificacionesView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 17/09/25.
//

import SwiftUI

struct NotificacionesView: View {
    var body: some View {
        VStack(spacing: 16) {

            // Header
            HStack {
                Label("Notificaciones", systemImage: "bell.fill")
                    .font(.title3.weight(.semibold))
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
            Spacer()
            
            // Lista de tarjetas
            ScrollView {
                VStack(spacing: 16) {
                    /*NotiCard(
                        titulo: "¡Tu medicamento está por caducar!",
                        detalle: "La fecha de caducidad de “_medicamento_” es: “00/00/0000” → 1 semana antes",
                        trailing: AnyView(
                            Image("calendario")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            )
                    )*/

                    NotiCard(
                        titulo: "¡Completa tus datos!",
                        detalle: "No olvides llenar los campos de Datos Personales, tu información es muy importante.\n→ Únicamente si te falta llenar información",
                        trailing: AnyView(Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.gray))
                    )

                    NotiCard(
                        titulo: "Botón SOS activado",
                        detalle: "Has llamado al contacto de emergencia y se le ha mandado un mensaje de que tienes un ataque de Anafilaxia → cuando se presione el botón SOS",
                        trailing: AnyView(
                            ZStack {
                                Image(systemName: "iphone.gen3.radiowaves.left.and.right")
                                Text("911")
                                    .font(.caption2.weight(.bold))
                                    .padding(4)
                                    .background(Circle().fill(.red))
                                    .foregroundStyle(.white)
                                    .offset(x: 14, y: -12)
                            }
                            .font(.title2)
                            .foregroundStyle(.purple)
                        )
                    )

                    /*NotiCard(
                        titulo: "¡Es momento de tomar tu medicamento!",
                        detalle: "No olvides tomar “_dosis_” de tu medicamento: “_medicamento_”.",
                        trailing: AnyView(
                            Image("medicamento")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        )
                    )*/
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }

            Spacer(minLength: 0)
            
            HStack(spacing: 30) {
                NavigationLink{
                    GeolocalizacionView()
                } label: {
                    Image(systemName: "house.fill")
                }
                // Image(systemName: "house.fill")
                Image(systemName: "bell.fill")
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
                // Image(systemName: "book.fill")
                NavigationLink{
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
        .background(Color(.systemBackground))
    }
}

// Componente de tarjeta de notificación
struct NotiCard: View {
    let titulo: String
    let detalle: String
    let trailing: AnyView

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(titulo)
                    .font(.headline)
                Text(detalle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            trailing
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemGray5))
                .shadow(color: .black.opacity(0.15), radius: 6, y: 4)
        )
    }
}

#Preview {
    NavigationStack { NotificacionesView() }
}
