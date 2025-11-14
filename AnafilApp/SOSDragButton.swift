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
  
        let isEnglish = user.idiomaSeleccionado == "English"
        let notiDetail = isEnglish
            ? "Emergency alert activated via slider button"
            : "Se ha activado la alerta de emergencia mediante el botón deslizante"
        
        let nuevaNoti = HistorialAcciones(
            tipo_accion: .sosCall,
            detalle: notiDetail
        )
        modelContext.insert(nuevaNoti)
        user.historialAcciones.append(nuevaNoti)
        
        // Preparar la info
        let numeroLimpio = user.contactoEmergencia.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        let mensajeEmergencia: String
        if isEnglish {
            mensajeEmergencia = """
            HELP! I am \(user.nombre). I am having a possible episode of ANAPHYLAXIS.
            Location: (Current Location)
            Blood Type: \(user.tipoSangre)
            Allergies: \(user.alergias)
            Diagnosis: \(user.diagnostico)
            """
        } else {
            mensajeEmergencia = """
            ¡AYUDA! soy \(user.nombre). Estoy teniendo un posible episodio de ANAFILAXIA.
            Ubicación: (Ubicación Actual)
            Sangre: \(user.tipoSangre)
            Alergias: \(user.alergias)
            Diagnóstico: \(user.diagnostico)
            """
        }
        
        print("Intentando contactar a: \(numeroLimpio)")
        print("Mensaje preparado: \(mensajeEmergencia)")
        
        if let url = URL(string: "tel://\(numeroLimpio)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        } else {
            print("Error: No se puede realizar la llamada. Probablemente estamos en el simulador...")
        }
    }
}
