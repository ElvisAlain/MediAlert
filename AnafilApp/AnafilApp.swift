//
//  MediAlertApp.swift
//  MediAlert
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI

@main
struct AnafilApp: App {
    @StateObject var userData = UserData() // Instancia única de UserData
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true // Bandera de la primera apertura(para que solo sea la primera vez)
    var body: some Scene {
        WindowGroup {
            // Si es la primer apertura, mostrar Registro | Si no, mostrar la Pantalla Principal de Geolocalización
            if isFirstLaunch {
                ContentView()
                    .environmentObject(userData)
            } else {
                NavigationStack {
                    GeolocalizacionView()
                }
                .environmentObject(userData)
            }
            
        }
    }
}
