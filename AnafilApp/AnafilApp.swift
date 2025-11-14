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

struct SOSDragButton: View {
    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]
    var currentUser: User? {users.first}
    
    @State private var offset: CGFloat = 0 // Para el movimiento
    let limiteActivacion: CGFloat = -80.0 // Negativo es arriba | Lo que debe subir
    
    var body: some View {
        ZStack {
            if offset < -10 { // Muestra flechita para arrastrar
                VStack {
                    Image(systemName: "chevron.up")
                        .font(.caption)
                        .foregroundStyle(.red.opacity(0.5))
                    Spacer().frame(height: 50)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: offset)
            }
            // Botón SOS
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.8))
                    .shadow(color: .red.opacity(0.4), radius: 6, x: 0, y: 3)
                Text("SOS")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(.white)
            }
            .frame(width: 60, height: 60)
            .offset(y: offset) // Movimiento
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let newY = value.translation.height // Solo movimiento hacia arriba y que no suba al 'infinito' (-150 máx.)
                        if newY < 0 && newY > -150 {
                            offset = newY
                        }
                    }
                    .onEnded {value in // Al soltar, verificamos si llegó al límite
                        if value.translation.height <= limiteActivacion {
                            activarSOS()
                        } // Animación de rebote para volver al centro
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            offset = 0
                        }
                    }
                )
            }
        .frame(width: 60, height:60)
        }
    
    private func activarSOS() {
        let generator = UIImpactFeedbackGenerator(style: .heavy) // FeedBack Hóptico - Vibración
        generator.impactOccurred()
        
        guard let user = currentUser else {return} // Guardar Noti
        
        let nuevaNoti = HistorialAcciones(
            tipo_accion: .sosCall,
            detalle: "Se ha activado la alerta de emergencia mediante el botón deslizante"
        )
        modelContext.insert(nuevaNoti)
        user.historialAcciones.append(nuevaNoti)
        // Preparar la info
        let numeroLimpio = user.contactoEmergencia.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mensajeEmergencia = """
        ¡AYUDA! soy \(user.nombre). Estoy teniendo un posible episodio de ANAFILAXIA.
        Ubicación: (Ubicación Actual)
        Sangre: \(user.tipoSangre)
        Alergias: \(user.alergias)
        Diagnóstico: \(user.diagnostico)
        """
        print("Intentando contactar a: \(numeroLimpio)")
        print("Mensaje preparado: \(mensajeEmergencia)")
        
        if let url = URL(string: "tel://\(numeroLimpio)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Error: No se puede realizar la llamada. Probablemente estamos en el simulador...")
        }
        /* NOTA TÉCNICA SOBRE SMS:
            iOS bloquea enviar SMS y llamar al mismo tiempo.
            Si prefieres enviar el SMS en lugar de llamar, cambia "tel://" por "sms:".
            Pero la llamada es más efectiva en una anafilaxia.
        */
    }
}
