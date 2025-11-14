//
//  LanguageButton.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 13/11/25.
//

import SwiftUI
import SwiftData

struct LanguageButton: View {
    @Query(sort: \User.nombre) var users: [User]
    var currentUser: User? { users.first } // Conexión
    
    var body: some View {
        Menu {
            // Opción 1: Español
            Button {
                cambiarIdioma(a: "Español")
            } label: {
                HStack{
                    Text("Español")
                    // Solo mostramos la palomita si este es el seleccionado
                    if currentUser?.idiomaSeleccionado == "Español" {
                        Image(systemName: "checkmark")
                    }
                }
            }
            
            // Opción 2: Inglés
            Button {
                cambiarIdioma(a: "English")
            } label: {
                HStack {
                    Text("English")
                    if currentUser?.idiomaSeleccionado == "English" {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: { // El ícono del globito que activa el menú
            Image (systemName: currentUser?.idiomaSeleccionado == "Español" ? "globe" : "globe.americas.fill")
                .font(.title3)
                .foregroundStyle(.blue)
        }
    }
    
    private func cambiarIdioma(a nuevoIdioma: String) {
        guard let user = currentUser else {return}
        
        // Si selecciona el mismo, no hacemos nada
        if user.idiomaSeleccionado == nuevoIdioma {
            return
        }
        // Si es diferente, lo actualizamos
        withAnimation {
            user.idiomaSeleccionado = nuevoIdioma
        }
    }
}
