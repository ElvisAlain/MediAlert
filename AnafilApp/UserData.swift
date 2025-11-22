//
//  UserData.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 07/10/25.
//

import Foundation
import SwiftData
import SwiftUI

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
    var fechaNacimiento: Date
    var tipoSangre: String
    var diagnostico: String
    var alergias: String
    
    @Attribute(.externalStorage)
    var profileImageData: Data?
    
    @Relationship(deleteRule: .cascade, inverse: \RecetaMedica.user)
    var recetas: [RecetaMedica] = []
    
    @Relationship(deleteRule: .cascade, inverse: \HistorialAcciones.user)
    var historialAcciones: [HistorialAcciones] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Adrenalina.user)
    var adrenalinas: [Adrenalina] = []
    
    var calculatedAge: Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: fechaNacimiento, to: now)
        return ageComponents.year ?? 0
    }
    
    func isProfileIncomplete() -> Bool {
        let isAgeMissing = self.calculatedAge == 0
        return direccion == "No especificada" ||
        peso == 0.0 ||
        tipoSangre == "N/A" ||
        alergias == "No especificada" ||
        isAgeMissing
    }
    
    init(
        nombre: String = "",
        apellidos: String = "",
        idiomaSeleccionado: String = "Español",
        telefono: String = "",
        contactoEmergencia: String = "",
        direccion: String = "No especificada",
        sexo: String = "No especificado",
        peso: Double = 0.0,
        fechaNacimiento: Date = Date(),
        tipoSangre: String = "N/A",
        diagnostico: String = "N/A",
        alergias: String = "No especificada",
        profileImageData: Data? = nil
    )   {
        self.nombre = nombre
        self.apellidos = apellidos
        self.idiomaSeleccionado = idiomaSeleccionado
        self.telefono = telefono
        self.contactoEmergencia = contactoEmergencia
        self.direccion = direccion
        self.sexo = sexo
        self.peso = peso
        self.fechaNacimiento = fechaNacimiento
        self.tipoSangre = tipoSangre
        self.diagnostico = diagnostico
        self.alergias = alergias
        self.profileImageData = profileImageData
    }
}
