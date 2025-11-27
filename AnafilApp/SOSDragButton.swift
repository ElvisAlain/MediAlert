//
//  SOSDragButton.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 13/11/25.
//

import SwiftUI
import SwiftData

struct SOSDragButton: View {
    @Environment(\.modelContext) private var modelContext
    @Query var users: [User]
    var currentUser: User? { users.first }
    
    // Estado para la animación de presión
    @State private var isPressing = false
    @State private var showHint = false // Para mostrar el mensaje si solo tocan
    @State private var showCallAlert = false
    
    // Configuración
    let pressDuration: Double = 2.0
    
    var body: some View {
        ZStack {
            // Círculo de fondo (animación de progreso/escala)
            Circle()
                .fill(Color.red.opacity(0.3))
                .frame(width: 80, height: 80)
                .scaleEffect(isPressing ? 1.5 : 1.0) // Crece al presionar
                .opacity(isPressing ? 1.0 : 0.0)
                .animation(.easeInOut(duration: pressDuration), value: isPressing)
            
            // Botón SOS Principal
            ZStack {
                Circle()
                    .fill(Color.red)
                    .shadow(color: .red.opacity(0.4), radius: 6, x: 0, y: 3)
                
                Text("SOS")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundStyle(.white)
            }
            .frame(width: 60, height: 60)
            .scaleEffect(isPressing ? 0.95 : 1.0) // Pequeño efecto de "apretar"
            .animation(.easeInOut(duration: 0.2), value: isPressing)
            // Gestos
            .onLongPressGesture(minimumDuration: pressDuration, pressing: { pressing in
                // Detecta cuando empieza y termina de presionar
                withAnimation {
                    self.isPressing = pressing
                    if pressing { showHint = false } // Ocultar pista si empieza a presionar bien
                }
            }, perform: {
                // Se ejecuta SOLO si cumplió los 2 segundos
                activarSOS()
                // Reset visual
                isPressing = false
            })
            // Gesto de tap: Toque corto
            .simultaneousGesture(TapGesture().onEnded {
                withAnimation {
                    showHint = true
                }
                // Ocultar la pista después de 2 segundos
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation { showHint = false }
                }
            })
            
            // Mensaje de Pista (Hint)
            if showHint {
                VStack {
                    Text(currentUser?.idiomaSeleccionado == "English" ? "Hold for 2s" : "Mantén 2s")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(8)
                        .offset(y: -50)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .frame(width: 80, height: 80)
        .alert("Modo Simulador", isPresented: $showCallAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("En un iPhone real, esto estaría llamando al: \(currentUser?.contactoEmergencia ?? "Sin numero")")
                }
    }
    
    private func activarSOS() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        guard let user = currentUser else { return }
        
        let isEnglish = user.idiomaSeleccionado == "English"
        
        // Crear Notificación en Historial
        let notiDetail = isEnglish
            ? "Emergency alert activated via SOS button"
            : "Se ha activado la alerta de emergencia mediante el botón SOS"
        
        let nuevaNoti = HistorialAcciones(
            tipo_accion: .sosCall,
            detalle: notiDetail
        )
        modelContext.insert(nuevaNoti)
        user.historialAcciones.append(nuevaNoti)
        
        // Preparar llamada
        let numeroLimpio = user.contactoEmergencia.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        print("Llamando a emergencia: \(numeroLimpio)")
        
        if let url = URL(string: "tel://\(numeroLimpio)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("No se puede llamar en simulador.")
            #if targetEnvironment(simulator)
            showCallAlert = true
            #endif
        }
    }
}
