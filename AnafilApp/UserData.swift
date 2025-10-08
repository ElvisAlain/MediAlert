//
//  UserData.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 07/10/25.
//

import Foundation
import Combine
import SwiftUI

// Permite notificar cuando cambian sus propiedades marcadas con Published
class UserData: ObservableObject {
    @Published var nombre: String = ""
    @Published var apellidos: String = ""
    @Published var idiomaSeleccionado: String = "Español" // Por defecto
    @Published var telefono: String = ""
    @Published var contactoEmergencia: String = ""
    // Falta el resto pero por ahora estos para pasar de ContentView a DatosPersonalesView con el botón Crear Cuenta
}
