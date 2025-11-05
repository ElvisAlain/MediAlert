//
//  ContentView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    // Estados locales: texto e idioma
    @State private var nombre: String = ""
    @State private var apellidos: String = ""
    @State private var telefono: String = ""
    @State private var contactoEmergencia: String = ""
    @State private var idiomaSeleccionado: String = "Español" // Por defecto
    
    // Errores por campo
    @State private var nombreError: String? = nil
    @State private var apellidosError: String? = nil
    @State private var telefonoError: String? = nil
    @State private var contactoError: String? = nil
    @State private var direccionError: String? = nil
    @State private var sexoError: String? = nil
    @State private var pesoError: String? = nil
    @State private var tipoSangreError: String? = nil
    @State private var diagnosticoError: String? = nil
    @State private var alergiasError: String? = nil
    
    // Bandera de primera vez y datos persistentes. La vista DatosPersonales se actualizará automáticamente cuando esta bandera cambie.
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    // Acceso al Contexto de SwiftData para guardar datos
    @Environment(\.modelContext) private var modelContext
    // Estados para el foco del teclado
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable { // Controlar el foco entre campos
        case nombre, apellidos, telefono, emergencia
    }
    
    private func clearErrors() {
        nombreError = nil
        apellidosError = nil
        telefonoError = nil
        contactoError = nil
    }
    
    func validateForm() -> Bool {
        clearErrors() // limpiar errores anteriores
        
        if nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { // Validar nombre
            nombreError = "Falta el nombre."
            focusedField = .nombre
            return false
        }
        if apellidos.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { // Validar apellidos
            apellidosError = "Faltan los apellidos."
            focusedField = .apellidos
            return false
        }
        if telefono.count != 10 || !telefono.allSatisfy({ $0.isNumber}) { // Validar teléfono propio
            telefonoError = "El teléfono propio debe tener 10 dígitos válidos."
            focusedField = .telefono
            return false
        }
        if contactoEmergencia.count != 10 || !contactoEmergencia.allSatisfy({ $0.isNumber}) { // Validar contacto de Emergencia
            contactoError = "El contacto de emergencia debe tener 10 dígitos válidos."
            focusedField = .emergencia
            return false
        }
        return true
    }
    
    func saveAndNavigate() {
       // Instancia del modelo Swift Data --> User
        let newUser = User(
            nombre: nombre,
            apellidos: apellidos,
            idiomaSeleccionado: idiomaSeleccionado,
            telefono: telefono,
            contactoEmergencia: contactoEmergencia,
            direccion: "No especificada",
            sexo: "No especificado",
            peso: 0.0,
            tipoSangre: "N/A",
            diagnostico: "N/A",
            alergias: "No especificada(s)",
        )
        modelContext.insert(newUser)
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
                
                // Campos de texto
                VStack(spacing: 6) {
                    VStack(spacing: 6) {
                        TextField("Nombre(s)", text: $nombre)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .nombre)
                        if let error = nombreError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }
                    }
                    VStack(spacing: 6) {
                        TextField("Apellidos", text: $apellidos)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .apellidos)
                        if let error = apellidosError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }
                    }
                    
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
                        .frame(height: 34)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.2))
                        )
                    }
                    .padding(.top, 6)
                    VStack(spacing: 6) {
                        TextField("Teléfono (10 dígitos)", text: $telefono)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad) // Solo números
                            .focused($focusedField, equals: .telefono)
                        if let error = telefonoError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }
                    }
                    VStack(spacing: 6) {
                        TextField("Contacto de emergencia (Teléfono)", text: $contactoEmergencia)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($focusedField, equals: .emergencia)
                        if let error = contactoError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 4)
                        }
                    }
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
        .modelContainer(for: User.self, inMemory: true)
}
