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
    @State private var isAdultConfirmed: Bool = false
    
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
    @State private var ageError: String? = nil
    
    // Bandera de primera vez y datos persistentes
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @Environment(\.modelContext) private var modelContext
    @FocusState private var focusedField: Field?
    
    private enum Field: Hashable {
        case nombre, apellidos, telefono, emergencia
    }
    
    private var isEnglish: Bool { idiomaSeleccionado == "English" }
    
    private func clearErrors() {
        nombreError = nil
        apellidosError = nil
        telefonoError = nil
        contactoError = nil
        ageError = nil
    }
    
    func validateForm() -> Bool {
        clearErrors() // limpiar errores anteriores
        
        if nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nombreError = isEnglish ? "Name is missing." : "Falta el nombre."
            focusedField = .nombre
            return false
        }
        if apellidos.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            apellidosError = isEnglish ? "Last name is missing." : "Faltan los apellidos."
            focusedField = .apellidos
            return false
        }
        if telefono.count != 10 || !telefono.allSatisfy({ $0.isNumber}) {
            telefonoError = isEnglish ? "Phone number must have 10 valid digits." : "El teléfono propio debe tener 10 dígitos válidos."
            focusedField = .telefono
            return false
        }
        if contactoEmergencia.count != 10 || !contactoEmergencia.allSatisfy({ $0.isNumber}) {
            contactoError = isEnglish ? "Emergency contact must have 10 valid digits." : "El contacto de emergencia debe tener 10 dígitos válidos."
            focusedField = .emergencia
            return false
        }
        if !isAdultConfirmed {
            ageError = isEnglish ? "You must confirm this field to continue." : "Debes confirmar este campo para continuar."
            return false
        }
        return true
    }
    
    func saveAndNavigate() {
        let newUser = User(
            nombre: nombre,
            apellidos: apellidos,
            idiomaSeleccionado: idiomaSeleccionado,
            telefono: telefono,
            contactoEmergencia: contactoEmergencia,
            direccion: "No especificada",
            sexo: "No especificado",
            peso: 0.0,
            fechaNacimiento: Date(),
            tipoSangre: "N/A",
            diagnostico: "N/A",
            alergias: "No especificada"
        )
        if newUser.isProfileIncomplete() {
            let msg = isEnglish ? "Don't forget to fill in the Personal Data fields, your information is very important." : "No olvides llenar los campos de Datos Personales, tu información es muy importante."
            let primeraNoti = HistorialAcciones (
                tipo_accion: .profileUpdate,
                detalle: msg
            )
            newUser.historialAcciones.append(primeraNoti)
        }
        modelContext.insert(newUser)
        isFirstLaunch = false
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
                        .foregroundStyle(Color.cmicaBlue) // Icono azul
                    Text(isEnglish ? "Registration" : "Registro")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.cmicaBlue) // Texto azul
                }
                .padding(.top, 16)
                
                Text(isEnglish ? "Enter requested data:" : "Ingresa los datos solicitados:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // Campos de texto
                VStack(spacing: 6) {
                    VStack(spacing: 6) {
                        TextField(isEnglish ? "Name(s)" : "Nombre(s)", text: $nombre)
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
                        TextField(isEnglish ? "Last Name" : "Apellidos", text: $apellidos)
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
                            if idiomaSeleccionado.isEmpty {
                                Text(isEnglish ? "Select Language" : "Selecciona idioma")
                                    .foregroundColor(.gray.opacity(0.6))
                            } else {
                                Text(idiomaSeleccionado)
                                    .foregroundColor(.primary)
                            }
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
                        TextField(isEnglish ? "Phone (10 digits)" : "Teléfono (10 dígitos)", text: $telefono)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
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
                        TextField(isEnglish ? "Emergency Contact (Phone)" : "Contacto de emergencia (Teléfono)", text: $contactoEmergencia)
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
                
                VStack(alignment: .leading, spacing: 4) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isAdultConfirmed.toggle()
                        }
                    }) {
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: isAdultConfirmed ? "checkmark.square.fill" : "square")
                                .font(.title3)
                                // CAMBIO: Checkbox azul institucional
                                .foregroundColor(isAdultConfirmed ? Color.cmicaBlue : .gray)
                            Text(isEnglish ? "I am of legal age or use the application under the supervision of a guardian." : "Soy mayor de edad o utilizo la aplicación bajo la supervisión de un tutor.")
                                .font(.footnote)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    if let error = ageError {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 34)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Navegar a la segunda pantalla
                Button {
                    if validateForm() {
                        saveAndNavigate()
                    }
                } label: {
                    Text(isEnglish ? "Create Account" : "Crear Cuenta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        // CAMBIO: Fondo azul institucional si está confirmado
                        .background(isAdultConfirmed ? Color.cmicaBlue : Color.gray)
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
