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
    // Calculamos las notificaciones ordenadas
    private var sortedNotificaciones: [HistorialAcciones] {
        currentUser?.historialAcciones.sorted(by: {$0.fecha_hora > $1.fecha_hora}) ?? []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Label("Notificaciones", systemImage: "bell.fill")
                    .font(.title3.weight(.semibold))
                Spacer()
                LanguageButton()
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            // Lista de tarjetas
            ScrollView {
                VStack(spacing: 16) {
                    if sortedNotificaciones.isEmpty {
                        Text("No tienes notificaciones nuevas.")
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
            Spacer(minLength: 0)
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
    
    @ViewBuilder // Helper para construir las tarjetas
    private func notiCard(for accion: HistorialAcciones) -> some View {
        switch accion.tipo_accion {
        case .profileUpdate:
            NotiCard(
                titulo: "¡Completa Tus Datos!",
                detalle: accion.detalle,
                trailing: AnyView(Image(systemName: "info.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.gray))
            )
        case .sosCall:
            NotiCard(
                titulo: "Botón SOS Activado",
                detalle: accion.detalle,
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
    var currentUser: User? {user.first}
    
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
