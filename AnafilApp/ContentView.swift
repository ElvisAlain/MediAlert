//
//  ContentView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI

struct ContentView: View {
    
    // Estados locales: texto e idioma
    @State private var nombre: String = ""
    @State private var apellidos: String = ""
    @State private var telefono: String = ""
    @State private var contactoEmergencia: String = ""
    @State private var idiomaSeleccionado: String = "Español" // Por defecto
    
    // Bandera de primera vez y datos persistentes. La vista DatosPersonales se actualizará automáticamente cuando esta bandera cambie.
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("nombre_key") var storedNombre: String = ""
    @AppStorage("apellidos_key") var storedApellidos: String = ""
    @AppStorage("telefono_key") var storedTelefono: String = ""
    @AppStorage("emergencia_key") var storedEmergencia: String = ""
    @AppStorage("idioma_key") var storedIdioma: String = "Español"
    
    @EnvironmentObject var userData: UserData // Pasar datos al modelo compartido UserData
    @State private var validationMessage: String? // Estados para la validación y el foco del teclado
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable { // Controlar el foco entre campos
        case nombre, apellidos, telefono, emergencia
    }
    
    func validateForm() -> Bool {
        validationMessage = nil
        if nombre.isEmpty {
            validationMessage = "Falta el nombre."
            focusedField = .nombre
            return false
        }
        if apellidos.isEmpty {
            validationMessage = "Faltan los apellidos."
            focusedField = .apellidos
            return false
        }
        if telefono.count != 10 || !telefono.allSatisfy({ $0.isNumber}) {
            validationMessage = "El teléfono propio debe tener 10 dígitos válidos."
            focusedField = .telefono
            return false
        }
        if contactoEmergencia.count != 10 || !contactoEmergencia.allSatisfy({ $0.isNumber}) {
            validationMessage = "El contacto de emergencia debe tener 10 dígitos válidos."
            focusedField = .emergencia
            return false
        }
        return true
    }
    
    func saveAndNavigate() {
        // Llenar el modelo de datos observable (UserData)
        userData.nombre = nombre
        userData.apellidos = apellidos
        userData.telefono = telefono
        userData.contactoEmergencia = contactoEmergencia
        userData.idiomaSeleccionado = idiomaSeleccionado
        
        // Persistir los datos en AppStorage para un futuro pre-llenado en DatosPersonalesView
        storedNombre = nombre
        storedApellidos = apellidos
        storedTelefono = telefono
        storedEmergencia = contactoEmergencia
        storedIdioma = idiomaSeleccionado
        
        isFirstLaunch = false // Bandera
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                
                // Título
                Image("anafilApp_main")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                
                // Logo
                Image("cmica_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 50)
                    .padding(.top, 8)
                
                // Subtítulo
                HStack(spacing: 6) {
                    Image(systemName: "doc.text")
                        .font(.title3)
                    Text("Registro")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .padding(.top, 16)
                
                Text("Ingresa los datos solicitados:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if let message = validationMessage {
                    Text(message)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                // Campos de texto
                VStack(spacing: 14) {
                    TextField("Nombre(s)", text: $nombre)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .nombre)
                    
                    TextField("Apellidos", text: $apellidos)
                        .textFieldStyle(.roundedBorder)
                        .focused($focusedField, equals: .apellidos)
                    
                    Menu {
                        Button("Español") { idiomaSeleccionado = "Español" }
                        Button("English") { idiomaSeleccionado = "English" }
                    } label: {
                        HStack {
                            Text(idiomaSeleccionado.isEmpty ? " Selecciona idioma" : idiomaSeleccionado)
                                .foregroundColor(idiomaSeleccionado.isEmpty ? .gray.opacity(0.6) : .primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray.opacity(0.6))
                                .padding(.trailing, 8)
                        }
                    }
                    .frame(height: 34)
                    .frame(maxWidth: .infinity)
                    .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.2))
                        )
                    
                    TextField("Teléfono (10 dígitos)", text: $telefono)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad) // Solo números
                        .focused($focusedField, equals: .telefono)
                    
                    TextField("Contacto de emergencia (Teléfono)", text: $contactoEmergencia)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: .emergencia)
                }
                .padding(.horizontal)
                
                // Navegar a la segunda pantalla (mockup geolocalización)
                Button {
                    if validateForm() { // Validar al presionar el botón
                        saveAndNavigate()
                    }
                } label: {
                    Text("Crear Cuenta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
