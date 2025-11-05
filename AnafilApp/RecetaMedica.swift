//
//  RecetaMedica.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 05/11/25.
//

import Foundation
import SwiftData

@Model
final class RecetaMedica {
    var fechaSubida: Date
    
    @Attribute(.externalStorage)
    var imagenRecetaData: Data?
    
    var user: User? // De qué usuario es la receta
    
    init(fechaSubida: Date = Date(), imagenRecetaData: Data? = nil) {
        self.fechaSubida = fechaSubida
        self.imagenRecetaData = imagenRecetaData
    }
}
