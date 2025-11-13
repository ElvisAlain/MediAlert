//
//  HistorialAcciones.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 06/11/25.
//

import Foundation
import SwiftData

@Model
final class HistorialAcciones {
    var tipo_accion: TipoAccion
    var fecha_hora: Date
    var detalle: String
    var leida: Bool = false
    var user: User?
    
    init(tipo_accion: TipoAccion, detalle: String, fecha_hora: Date = Date()) {
        self.tipo_accion = tipo_accion
        self.detalle = detalle
        self.fecha_hora = fecha_hora
        self.leida = false
    }
}

enum TipoAccion: String, Codable, CaseIterable { // Enum como definí en la Base de Datos
    case sosCall = "SOS_CALL"
    case profileUpdate = "PROFILE_UPDATE"
}
