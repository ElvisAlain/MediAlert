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
        .onAppear {
            checarYEnviarNotificacion()
        }
    }
    
    private func checarYEnviarNotificacion() {
        guard let user = users.first else {return} // Existe el usuario?
        guard user.isProfileIncomplete() else {return} // Verificar si el perfil está incompleto
        
        
        let nuevaNoti = HistorialAcciones(
            tipo_accion: .profileUpdate,
            detalle: "No olvides llenar los campos de Datos Personales, tu información es muy importante."
        )
        modelContext.insert(nuevaNoti)
        user.historialAcciones.append(nuevaNoti)
    }
}
