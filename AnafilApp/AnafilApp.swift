//
//  AnafilApp.swift
//  AnafilApp
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
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @Query var users: [User]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Group {
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
        guard let user = users.first else {return}
        guard user.isProfileIncomplete() else {return}
        
        // Detección de idioma para la notificación automática
        let isEnglish = user.idiomaSeleccionado == "English"
        let message = isEnglish
            ? "Don't forget to fill in the Personal Data fields, your information is very important."
            : "No olvides llenar los campos de Datos Personales, tu información es muy importante."
        
        let nuevaNoti = HistorialAcciones(
            tipo_accion: .profileUpdate,
            detalle: message
        )
        modelContext.insert(nuevaNoti)
        user.historialAcciones.append(nuevaNoti)
    }
}
