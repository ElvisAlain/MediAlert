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
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true // Bandera de la primera apertura (para que solo sea la primera vez)
    var body: some Scene {
        WindowGroup {
            // Si es la primer apertura, mostrar Registro | Si no, mostrar la Pantalla Principal de Geolocalización
            if isFirstLaunch {
                ContentView()
            } else {
                NavigationStack {
                    GeolocalizacionView()
                }
            }
        }
        .modelContainer(for: User.self)
    }
}
