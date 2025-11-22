//
//  Adrenalina.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 21/11/25.
//

import Foundation
import SwiftData

@Model
final class Adrenalina {
    var fechaCaducidad: Date
    var fechaRegistro: Date
    var marca: String
    var user: User?
    
    init(fechaCaducidad: Date, marca: String = "") {
        self.fechaCaducidad = fechaCaducidad
        self.marca = marca
        self.fechaRegistro = Date()
    }
    
    // Para saber el estado
    var estado: EstadoAdrenalina {
        let hoy = Date()
        if fechaCaducidad < hoy {
            return .caducada
        } else if let mesDiferencia = Calendar.current.date(byAdding: .month, value: -1, to: fechaCaducidad), hoy > mesDiferencia {
            return .porCaducar // Menos de un mes
        } else {
            return .vigente
        }
    }
}

enum EstadoAdrenalina {
    case vigente
    case porCaducar
    case caducada
}
