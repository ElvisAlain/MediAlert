//
//  DatosPersonalesView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 17/09/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct DatosPersonalesView: View {
    @State private var isEditing: Bool = false
    @State private var showSaveConfirmation: Bool = false
    @Query(sort: \User.nombre) var users: [User]
    var currentUser: User? { users.first }
    
    // 1. Acceso a Idioma
    var isEnglish: Bool { currentUser?.idiomaSeleccionado == "English" }
    
    // Estados locales para la edición
    @State private var nombre: String = ""
    @State private var apellidos: String = ""
    @State private var telefono: String = ""
    @State private var contactoEmergencia: String = ""
    @State private var direccion: String = ""
    @State private var sexo: String = ""
    @State private var peso: Double = 0.0
    @State private var fechaNacimiento: Date = Date()
    @State private var tipoSangre: String = ""
    @State private var diagnostico: String = ""
    @State private var alergias: String = ""
    
    // Estados para el manejo de Errores
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
    
    // Estados para la Foto de Perfil
    @State private var profileImage: Image?
    @State private var profileImageData: Data?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showPhotoGallery: Bool = false
    
    // Cargar los datos del modelo
    private func loadUserData() {
        guard let user = currentUser else { return }
        nombre = user.nombre
        apellidos = user.apellidos
        telefono = user.telefono
        contactoEmergencia = user.contactoEmergencia
        direccion = user.direccion
        sexo = user.sexo
        peso = user.peso
        fechaNacimiento = user.fechaNacimiento
        tipoSangre = user.tipoSangre
        diagnostico = user.diagnostico
        alergias = user.alergias
        
        if let data = user.profileImageData, let uiImage = UIImage(data: data) {
            profileImage = Image(uiImage: uiImage)
            profileImageData = data
        } else {
            profileImage = nil
            profileImageData = nil
        }
    }
    
    private func clearErrors() {
        nombreError = nil
        apellidosError = nil
        telefonoError = nil
        contactoError = nil
        direccionError = nil
        sexoError = nil
        pesoError = nil
        tipoSangreError = nil
        diagnosticoError = nil
        alergiasError = nil
    }
    
    private func calculateAge(from date: Date) -> Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        return ageComponents.year ?? 0
    }
    
    private func validateAndSave() {
        clearErrors()
        var isValid = true
        
        if nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nombreError = isEnglish ? "Name is missing." : "Falta el nombre."
            isValid = false
        }
        if apellidos.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            apellidosError = isEnglish ? "Last name is missing." : "Faltan los apellidos."
            isValid = false
        }
        if telefono.count != 10 || !telefono.allSatisfy({ $0.isNumber}) {
            telefonoError = isEnglish ? "Phone must have 10 valid digits." : "El teléfono propio debe tener 10 dígitos válidos."
            isValid = false
        }
        if contactoEmergencia.count != 10 || !contactoEmergencia.allSatisfy({ $0.isNumber}) {
            contactoError = isEnglish ? "Emergency contact must have 10 valid digits." : "El contacto de emergencia debe tener 10 dígitos válidos."
            isValid = false
        }
        if direccion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            direccionError = isEnglish ? "Address is missing." : "Falta la dirección."
            isValid = false
        }
        if diagnostico.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            diagnosticoError = isEnglish ? "Diagnosis is missing." : "Falta el diagnóstico."
            isValid = false
        }
        if alergias.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alergiasError = isEnglish ? "Allergy(ies) missing." : "Falta(n) la(s) alergía(s)."
            isValid = false
        }
        if peso <= 0.0 {
            pesoError = isEnglish ? "Weight must be greater than 0." : "El peso debe ser mayor a 0."
            isValid = false
        }
        if sexo == "No especificado" || sexo == "Unspecified" {
            sexoError = isEnglish ? "Select a sex." : "Selecciona un sexo."
            isValid = false
        }
        if tipoSangre == "N/A" {
            tipoSangreError = isEnglish ? "Select a blood type." : "Selecciona un tipo de sangre."
            isValid = false
        }
        
        guard isValid else { return }
        
        let maxNombre = 25
        let maxApellidos = 25
        let maxOtros = 40
        
        if nombre.count > maxNombre {
            nombreError = isEnglish ? "Name must not exceed \(maxNombre) characters." : "El nombre no debe exceder los \(maxNombre) caracteres."
            isValid = false
        }
        if apellidos.count > maxApellidos {
            apellidosError = isEnglish ? "Last name must not exceed \(maxApellidos) characters." : "Los apellidos no debe exceder los \(maxApellidos) caracteres."
            isValid = false
        }
        if direccion.count > maxOtros {
            direccionError = isEnglish ? "Address must not exceed \(maxOtros) characters." : "La dirección no debe exceder los \(maxOtros) caracteres."
            isValid = false
        }
        if diagnostico.count > maxOtros {
            diagnosticoError = isEnglish ? "Diagnosis must not exceed \(maxOtros) characters." : "El diagnóstico no debe exceder los \(maxOtros) caracteres."
            isValid = false
        }
        if alergias.count > maxOtros {
            alergiasError = isEnglish ? "Allergies must not exceed \(maxOtros) characters." : "Las alergias no debe exceder los \(maxOtros) caracteres."
            isValid = false
        }
        
        guard isValid else { return }
        
        guard let user = currentUser else { return }
        
        user.nombre = nombre
        user.apellidos = apellidos
        user.telefono = telefono
        user.contactoEmergencia = contactoEmergencia
        user.direccion = direccion
        user.sexo = sexo
        user.peso = peso
        user.fechaNacimiento = fechaNacimiento
        user.tipoSangre = tipoSangre
        user.diagnostico = diagnostico
        user.alergias = alergias
        user.profileImageData = profileImageData
        
        isEditing = false
        withAnimation{ showSaveConfirmation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showSaveConfirmation = false }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Label(isEnglish ? "Personal Data" : "Datos Personales", systemImage: "info.circle")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.cmicaBlue)
                Spacer()
                HStack(spacing: 14) {
                    NotificacionesBellView()
                    LanguageButton()
                }
                .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)

            // Info Usuario
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color(.secondarySystemBackground))
                    if let profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(.gray.opacity(0.7))
                            .padding(6)
                    }
                    if isEditing {
                        Circle()
                            .fill(Color.black.opacity(0.4))
                        Image(systemName: "camera.fill")
                            .foregroundStyle(.white)
                            .font(.title3)
                    }
                }
                .frame(width: 56, height: 56)
                .onTapGesture {
                    if isEditing {
                        showPhotoGallery = true
                    }
                }

                Text(currentUser?.nombre ?? (isEnglish ? "User not found" : "Usuario no encontrado"))
                    .font(.title3.weight(.semibold))
                Spacer()
                
                Button {
                    if isEditing {
                        validateAndSave()
                    } else {
                        loadUserData()
                        isEditing.toggle()
                    }
                } label: {
                    Text(isEditing ? (isEnglish ? "Save" : "Guardar") : (isEnglish ? "Edit" : "Editar"))
                        .font(.callout.weight(.semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.cmicaBlue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 8)
            
            // Lista de chips
            ScrollView {
                if currentUser != nil {
                    let bloodTypes = ["N/A", "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
                    let sexOptions = isEnglish ? ["Unspecified", "Male", "Female", "Other"] : ["No especificado","Hombre", "Mujer", "Otro"]
                    
                    VStack(spacing: 14) {
                        ChipRow(titulo: isEnglish ? "Name: " : "Nombre: ", text: $nombre, editable: isEditing, error: nombreError)
                        ChipRow(titulo: isEnglish ? "Last Name: " : "Apellidos: ", text: $apellidos, editable: isEditing, error: apellidosError)
                        ChipRow(titulo: isEnglish ? "Phone: " : "Teléfono: ", text: $telefono, editable: isEditing, error: telefonoError)
                        ChipRow(titulo: isEnglish ? "Emergency Contact: " : "Contacto Emergencias: ", text: $contactoEmergencia, editable: isEditing, error: contactoError)
                        ChipRow(titulo: isEnglish ? "Address: " : "Dirección: ", text: $direccion, editable: isEditing, error: direccionError)
                        PickerChipRow(titulo: isEnglish ? "Sex: " : "Sexo: ", selection: $sexo, options: sexOptions, editable: isEditing, error: sexoError)
                        DoubleChipRow(titulo: isEnglish ? "Weight (Kg):" : "Peso (Kg) :", value: $peso, editable: isEditing, error: pesoError)
                        DateChipRow(titulo: isEnglish ? "Date of Birth: " : "Fecha de Nacimiento: ", selection: $fechaNacimiento, editable: isEditing)
                        
                        let anosText = isEnglish ? " years" : " años"
                        ChipRow(titulo: isEnglish ? "Age: " : "Edad: ", text: .constant("\(calculateAge(from: fechaNacimiento))" + anosText), editable: false)
                        
                        PickerChipRow(titulo: isEnglish ? "Blood Type: " : "Tipo de sangre: ", selection: $tipoSangre, options: bloodTypes, editable: isEditing, error: tipoSangreError)
                        ChipRow(titulo: isEnglish ? "Diagnosis: " : "Diagnóstico: ", text: $diagnostico, editable: isEditing, error: diagnosticoError)
                        ChipRow(titulo: isEnglish ? "Allergies: " : "Alergias: ", text: $alergias, editable: isEditing, error: alergiasError)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                    .onAppear { if !isEditing { loadUserData() } }
                } else {
                    Text(isEnglish ? "Loading User Data..." : "Cargando Datos del Usuario...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            
            VStack {
                if showSaveConfirmation {
                    Text(isEnglish ? "Data saved!" : "¡Datos guardados!")
                        .font(.caption.weight(.semibold))
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .foregroundStyle(Color.green)
                        .cornerRadius(8)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
            
            // Tab bar
            Spacer(minLength: 0)
            MenuInferior(activeTab: "perfil")
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .photosPicker(isPresented: $showPhotoGallery, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) {_, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    self.profileImageData = data
                    if let uiImage = UIImage(data: data) {
                        self.profileImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
}

// Estructura Chip
struct ChipRow: View {
    let titulo: String
    var editable: Bool = false
    @Binding var text: String
    var error: String?

    init(titulo: String, text: Binding<String>, editable: Bool = false, error: String? = nil) {
        self.titulo = titulo
        self._text = text
        self.editable = editable
        self.error = error
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 2) {
                    Text(titulo)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.cmicaBlue.opacity(0.9))
                        .layoutPriority(1)
                    
                    if editable {
                        TextField("", text: $text)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)
                            .lineLimit(1)
                    } else {
                        Text(text)
                            .lineLimit(1)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(editable ? Color.cmicaBlue.opacity(0.1) : Color(.systemGray5))
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            )
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 18)
            }
        }
    }
}

// Chip para Números Double
struct DoubleChipRow: View {
    let titulo: String
    @Binding var value: Double
    var editable: Bool = false
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 2) {
                    Text(titulo)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.cmicaBlue.opacity(0.9))
                    if editable {
                        TextField("", value: $value, format: .number.precision(.fractionLength(2)))
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)
                            .keyboardType(.decimalPad)
                    } else {
                        Text(value, format: .number.precision(.fractionLength(2)))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(editable ? Color.cmicaBlue.opacity(0.1) : Color(.systemGray5))
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            )
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 18)
            }
        }
    }
}

// Chip con Picker (String)
struct PickerChipRow: View {
    let titulo: String
    @Binding var selection: String
    var options: [String]
    var editable: Bool = false
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 2) {
                    Text(titulo)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.cmicaBlue.opacity(0.9))
                    
                    if editable {
                        Picker(titulo, selection: $selection) {
                            ForEach(options, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.primary)
                        
                    } else {
                        Text(selection)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(editable ? Color.cmicaBlue.opacity(0.1) : Color(.systemGray5))
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            )
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 18)
            }
        }
    }
}

// Chip para Date
struct DateChipRow: View {
    let titulo: String
    @Binding var selection: Date
    var editable: Bool = false
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 2) {
                    Text(titulo)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.cmicaBlue.opacity(0.9))
                    
                    if editable {
                        DatePicker(
                            "",
                            selection: $selection,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .tint(Color.cmicaBlue) // DatePicker en azul institucional
                    } else {
                        Text(selection, style: .date)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(editable ? Color.cmicaBlue.opacity(0.1) : Color(.systemGray5))
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            )
            
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal, 18)
            }
        }
    }
}

#Preview {
    NavigationStack { DatosPersonalesView() }
}
