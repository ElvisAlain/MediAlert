//
//  MediAlertApp.swift
//  MediAlert
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI
import SwiftData

@main
struct AnafilApp: App {
    var body: some Scene {
        WindowGroup {
            AnafilAppRoot()
        }
        .modelContainer(for: User.self)
    }
}

struct AnafilAppRoot: View {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true // Bandera de la primera apertura (para que solo sea la primera vez)
    @Environment(\.scenePhase) var scenePhase // Primer plano?
    @Query var users: [User] // Verificar perfil
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Group {
            // Si es la primer apertura, mostrar Registro | Si no, mostrar la Pantalla Principal de Geolocalización
            if isFirstLaunch {
                ContentView()
            } else {
                NavigationStack {
                    GeolocalizacionView()
                }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                checarYEnviarNotificacion()
            }
        }
    }
    
    private func checarYEnviarNotificacion() {
        guard let user = users.first else {return} // Existe el usuario?
        guard user.isProfileIncomplete() else {return} // Verificar si el perfil está incompleto
        
        let ultimasNotis = user.historialAcciones // Tiempo de espera, por si el usuario sale y se mete constantemente
            .filter { $0.tipo_accion == .profileUpdate}
            .sorted { $0.fecha_hora > $1.fecha_hora}
        let tiempoDeEspera: TimeInterval = 0 // Modificar timepo de espera
        
        let debeEnviarNuevaNoti: Bool
        if let ultimaNoti = ultimasNotis.first { // Si ya existe una, vemos si pasó el tiempo de espera
            debeEnviarNuevaNoti = Date().timeIntervalSince(ultimaNoti.fecha_hora) > tiempoDeEspera
        } else {
            debeEnviarNuevaNoti = true // Si no hay notificaciones previas de este tipo, enviamos
        }
        
        if debeEnviarNuevaNoti {
            let nuevaNoti = HistorialAcciones(
                tipo_accion: .profileUpdate,
                detalle: "No olvides llenar los campos de Datos Personales, tu información es muy importante."
            )
            modelContext.insert(nuevaNoti)
            user.historialAcciones.append(nuevaNoti)
            print("Notificación de perfil incompleto generada al abrir la app.")
        }
    }
}
