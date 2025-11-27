//
//  NotificacionesView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 17/09/25.
//

import SwiftUI
import SwiftData

struct NotificacionesView: View {
    // Conexión a SwiftData
    @Query(sort: \User.nombre) var users: [User]
    var currentUser: User? { users.first }
    
    // 1. Acceso a Idioma
    var isEnglish: Bool { currentUser?.idiomaSeleccionado == "English" }
    
    // Calculamos las notificaciones ordenadas
    private var sortedNotificaciones: [HistorialAcciones] {
        currentUser?.historialAcciones.sorted(by: {$0.fecha_hora > $1.fecha_hora}) ?? []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            HStack {
                Label(isEnglish ? "Notifications" : "Notificaciones", systemImage: "bell.fill")
                    .font(.title3.weight(.semibold))
                Spacer()
                HStack(spacing: 14) {
                    // Aquí solo ponemos el botón de idioma, ya que estamos en la vista de notificaciones
                    LanguageButton()
                }
                .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            // Lista de tarjetas
            ScrollView {
                VStack(spacing: 16) {
                    if sortedNotificaciones.isEmpty {
                        Text(isEnglish ? "You have no new notifications." : "No tienes notificaciones nuevas.")
                            .foregroundStyle(.secondary)
                            .padding(.top, 50)
                    } else {
                        ForEach(sortedNotificaciones) { accion in  // Iterar sobre el historial de acciones
                            notiCard(for: accion)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
            }
            
            Spacer(minLength:0)
            
            // Menú Inferior (Sin selección activa)
            MenuInferior(activeTab: "")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            marcarComoLeidas()
        }
    }
    
    private func marcarComoLeidas() { // Limpiar la bolita roja
        guard let user = currentUser else {return}
        let noLeidas = user.historialAcciones.filter { $0.leida == false } // Filtrar las NO leídas
        for noti in noLeidas {
            noti.leida = true
        }
    }
    
    @ViewBuilder
    private func notiCard(for accion: HistorialAcciones) -> some View {
        // Detalle dinámico según el tipo de acción y el idioma actual
        var detalleDinamico: String {
            switch accion.tipo_accion {
            case .profileUpdate:
                return isEnglish
                    ? "Don't forget to fill in the Personal Data fields, your information is very important."
                    : "No olvides llenar los campos de Datos Personales, tu información es muy importante."
            case .sosCall:
                 return isEnglish
                    ? "Emergency alert activated via SOS button."
                    : "Se ha activado la alerta de emergencia mediante el botón SOS."
            case .expiryWarning:
                return accion.detalle
            }
        }

        switch accion.tipo_accion {
        case .profileUpdate:
            NotiCard(
                titulo: isEnglish ? "Complete Your Data!" : "¡Completa Tus Datos!",
                detalle: detalleDinamico, // Variable Dinámica
                trailing: AnyView(Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.gray))
            )
        case .sosCall:
            NotiCard(
                titulo: isEnglish ? "SOS Button Activated" : "Botón SOS Activado",
                detalle: detalleDinamico,
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
        case .expiryWarning:
            NotiCard(
                titulo: isEnglish ? "Adrenaline Alert" : "Alerta de Adrenalina",
                detalle: accion.detalle,
                trailing: AnyView(
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                )
            )
        }
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

struct NotificacionesBellView: View {
    @Query(sort: \User.nombre) var user: [User]
    var currentUser: User? { user.first }
    
    var body: some View {
        NavigationLink {
            NotificacionesView()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell.fill")
                    .font(.title3)
                    .padding(.top, 5)
                    .padding(.trailing, 5)
                
                if let user = currentUser {
                    // Contamos las notificaciones no leídas
                    let noLeidas = user.historialAcciones.filter{ !$0.leida }.count
                    
                    if noLeidas > 0 {
                        Text("\(noLeidas)")
                            .font(.caption2).bold()
                            .foregroundStyle(.white)
                            .frame(width: 18, height: 18)
                            .background(.red)
                            .clipShape(Circle())
                            .offset(x: 5, y: -5) // La bolita en la esquina
                    }
                }
            }
        }
    }
}
