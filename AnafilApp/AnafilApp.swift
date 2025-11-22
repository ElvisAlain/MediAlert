//
//  AnafilApp.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI
import SwiftData

extension Color {
    static let cmicaBlue = Color(red: 0.0, green: 0.29, blue: 0.56)
}

@main
struct AnafilApp: App {
    // Agregamos un init para pedir permisos en cuanto arranca la app
    init() {
        NotificationManager.shared.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            AnafilAppRoot()
                .tint(.cmicaBlue)
        }
        // Adrenalina.self al array
        .modelContainer(for: [User.self, RecetaMedica.self, Adrenalina.self, HistorialAcciones.self])
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
            checarNotificaciones()
        }
    }
    
    private func checarNotificaciones() {
        guard let user = users.first else { return }
        let isEnglish = user.idiomaSeleccionado == "English"
        
        // Checar Perfil Incompleto
        if user.isProfileIncomplete() {
            let ultimaEsPerfil = user.historialAcciones.last?.tipo_accion == .profileUpdate
            
            if !ultimaEsPerfil {
                let message = isEnglish
                    ? "Don't forget to fill in the Personal Data fields, your information is very important."
                    : "No olvides llenar los campos de Datos Personales, tu información es muy importante."
                
                let nuevaNoti = HistorialAcciones(
                    tipo_accion: .profileUpdate,
                    detalle: message
                )
                user.historialAcciones.append(nuevaNoti)
            }
        }
        
        // Checar Caducidad de Adrenalinas
        checkAdrenalineExpiration(user: user, isEnglish: isEnglish)
    }
    
    private func checkAdrenalineExpiration(user: User, isEnglish: Bool) {
        let hoy = Date()
        let calendar = Calendar.current
        
        for adrenalina in user.adrenalinas {
            var mensaje: String? = nil
            
            // A) Calcular fechas límite
            guard let unMesAntes = calendar.date(byAdding: .month, value: -1, to: adrenalina.fechaCaducidad),
                  let unaSemanaAntes = calendar.date(byAdding: .day, value: -7, to: adrenalina.fechaCaducidad) else { continue }
            
            // B) Lógica de Estado
            
            // Caso 1: Ya caducó (desde ayer hacia atrás)
            if adrenalina.fechaCaducidad < hoy {
                mensaje = isEnglish
                    ? "Your adrenaline has EXPIRED. Replace it immediately."
                    : "Tu adrenalina ha CADUCADO. Reemplázala inmediatamente."
            }
            // Caso 2: Queda menos de una semana (entre una semana antes y hoy)
            else if hoy >= unaSemanaAntes {
                mensaje = isEnglish
                    ? "Urgent: Adrenaline expires in less than 7 days."
                    : "Urgente: Tu adrenalina caduca en menos de 7 días."
            }
            // Caso 3: Queda menos de un mes (entre un mes antes y una semana antes)
            else if hoy >= unMesAntes {
                mensaje = isEnglish
                    ? "Warning: Adrenaline expires in less than a month."
                    : "Aviso: Tu adrenalina caduca en menos de un mes."
            }
            
            // C) Insertar en la Base de Datos
            if let msg = mensaje {
                // Verificamos si ya le avisamos HOY sobre ESTA adrenalina para no llenar la lista
                let yaNotificadoHoy = user.historialAcciones.contains { accion in
                    let esMismoTipo = accion.tipo_accion == .expiryWarning
                    let esMismoDetalle = accion.detalle == msg
                    let fueHoy = calendar.isDate(accion.fecha_hora, inSameDayAs: hoy)
                    return esMismoTipo && esMismoDetalle && fueHoy
                }
                
                if !yaNotificadoHoy {
                    let nuevaNoti = HistorialAcciones(
                        tipo_accion: .expiryWarning,
                        detalle: msg
                    )
                    user.historialAcciones.append(nuevaNoti)
                }
            }
        }
    }
}
