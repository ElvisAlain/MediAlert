//
//  UserData.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 07/10/25.
//

import Foundation
import SwiftData

@Model

final class User {
    var nombre: String
    var apellidos: String
    var idiomaSeleccionado: String
    var telefono: String
    var contactoEmergencia: String
    var direccion: String
    var sexo: String
    var peso: Double
    var edad: Int
    var tipoSangre: String
    var diagnostico: String
    var alergias: String
    
    init(
        nombre: String = "",
        apellidos: String = "",
        idiomaSeleccionado: String = "Español",
        telefono: String = "",
        contactoEmergencia: String = "",
        direccion: String = "No especificada",
        sexo: String = "No especificado",
        peso: Double = 0.0,
        edad: Int = 0,
        tipoSangre: String = "N/A",
        diagnostico: String = "N/A",
        alergias: String = "No especificada"
    )   {
        self.nombre = nombre
        self.apellidos = apellidos
        self.idiomaSeleccionado = idiomaSeleccionado
        self.telefono = telefono
        self.contactoEmergencia = contactoEmergencia
        self.direccion = direccion
        self.sexo = sexo
        self.peso = peso
        self.edad = edad
        self.tipoSangre = tipoSangre
        self.diagnostico = diagnostico
        self.alergias = alergias
    }
    
}
