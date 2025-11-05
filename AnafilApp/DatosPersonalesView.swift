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
    @State private var showSaveConfirmation: Bool = false // Retro al Usuario
    @Query(sort: \User.nombre) var users: [User] // Cargar Usuario
    var currentUser: User? { users.first }
    
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
    @State private var profileImage: Image? // Mostrar en UI
    @State private var profileImageData: Data? // Guardar en DB
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showPhotoOptions: Bool = false // Para el menú Galería o Cámara
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
    
    // Limpiar Errores
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
    
    // Calcular Edad
    private func calculateAge(from date: Date) -> Int {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: now)
        return ageComponents.year ?? 0
    }
    
    // Validar el 'Guardar' datos
    private func validateAndSave() {
        clearErrors() // Limpiar errores antiguos
        var isValid = true
        if nombre.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            nombreError = "Falta el nombre."
            isValid = false
        }
        if apellidos.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            apellidosError = "Faltan los apellidos."
            isValid = false
        }
        if telefono.count != 10 || !telefono.allSatisfy({ $0.isNumber}) {
            telefonoError = "El teléfono propio debe tener 10 dígitos válidos."
            isValid = false
        }
        if contactoEmergencia.count != 10 || !contactoEmergencia.allSatisfy({ $0.isNumber}) {
            contactoError = "El contacto de emergencia debe tener 10 dígitos válidos."
            isValid = false
        }
        if direccion.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            direccionError = "Falta la dirección."
            isValid = false
        }
        if diagnostico.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            diagnosticoError = "Falta el diagnóstico."
            isValid = false
        }
        if alergias.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alergiasError = "Falta(n) la(s) alergía(s)."
            isValid = false
        }
        if peso <= 0.0 {
            pesoError = "El peso debe ser mayor a 0."
            isValid = false
        }
        if sexo == "No especificado" {
            sexoError = "Selecciona un sexo."
            isValid = false
        }
        if tipoSangre == "N/A" {
            tipoSangreError = "Selecciona un tipo de sangre."
            isValid = false
        }
        // Si no es válido, nos detenemos aquí
        guard isValid else { return }
        
        // Si sí es válido, guardamos los datos en el modelo
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
            
        // Salir del Modo edición y Mostrar Alerta
        isEditing = false
        withAnimation{ showSaveConfirmation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation { showSaveConfirmation = false }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if showSaveConfirmation {
                Text("¡Datos guardados!")
                    .font(.caption.weight(.semibold))
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                    .foregroundStyle(Color.green)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                    .zIndex(1) // Al frente
            }
            HStack {
                Label("Datos Personales", systemImage: "info.circle")
                    .font(.title3.weight(.semibold))
                Spacer()
                HStack(spacing: 14) {
                    NavigationLink{ NotificacionesView() } label: {
                        Image(systemName: "bell.fill")
                    }
                    Image(systemName: currentUser?.idiomaSeleccionado == "Español" ? "globe": "globe.fill")
                }
                .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color(.secondarySystemBackground))
                    if let profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 56, height: 56) // Aseguramos el tamaño
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
                        showPhotoOptions = true // Activa el menú de opciones
                    }
                }

                Text(currentUser?.nombre ?? "Usuario no encontrado")
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
                    Text(isEditing ? "Guardar" : "Editar")
                        .font(.callout.weight(.semibold))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)

            // Lista de chips
            ScrollView {
                if currentUser != nil {
                    // Opciones de Tipos de Sangre
                    let bloodTypes = ["N/A", "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
                    let sexOptions = ["No especificado","Hombre", "Mujer", "Otro"]
                    
                    VStack(spacing: 14) {
                        ChipRow(titulo: "Nombre: ", text: $nombre, editable: isEditing, error: nombreError)
                        ChipRow(titulo: "Apellidos: ", text: $apellidos, editable: isEditing, error: apellidosError)
                        ChipRow(titulo: "Teléfono: ", text: $telefono, editable: isEditing, error: telefonoError)
                        ChipRow(titulo: "Contacto Emergencias: ", text: $contactoEmergencia, editable: isEditing, error: contactoError)
                        ChipRow(titulo: "Dirección: ", text: $direccion, editable: isEditing, error: direccionError)
                        PickerChipRow(titulo: "Sexo: ", selection: $sexo, options: sexOptions, editable: isEditing, error: sexoError)
                        DoubleChipRow(titulo: "Peso (Kg) :", value: $peso, editable: isEditing, error: pesoError)
                        DateChipRow(titulo: "Fecha de Nacimiento: ", selection: $fechaNacimiento, editable: isEditing)
                        ChipRow(titulo: "Edad: ", text: .constant("\(calculateAge(from: fechaNacimiento)) años"), editable: false)
                        PickerChipRow(titulo: "Tipo de sangre: ", selection: $tipoSangre, options: bloodTypes, editable: isEditing, error: tipoSangreError)
                        ChipRow(titulo: "Diagnóstico: ", text: $diagnostico, editable: isEditing, error: diagnosticoError)
                        ChipRow(titulo: "Alergias: ", text: $alergias, editable: isEditing, error: alergiasError)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .onAppear { if !isEditing { loadUserData() } }
                } else {
                    Text("Cargando Datos del Usuario...")
                        .foregroundColor(.gray)
                        .padding()
                }
            }

            // Tab bar (mock, estático)
            HStack(spacing: 30) {
                NavigationLink{
                    GeolocalizacionView()
                } label: {
                    Image(systemName: "house.fill")
                }
                NavigationLink{
                    BotiquinView()
                } label: {
                    Image(systemName: "cross.case.fill")
                }
                ZStack {
                    Circle().fill(Color(.systemBackground))
                        .frame(width: 56, height: 56)
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                    Text("SOS")
                        .font(.headline)
                }
                NavigationLink {GuiasView()} label: {Image(systemName: "book.fill")}
                // Image(systemName: "book.fill")
                Image(systemName: "person.crop.circle.fill")
            }
            .font(.title2)
            .padding(.vertical, 10)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .confirmationDialog("Seleccionar Foto", isPresented: $showPhotoOptions){
            Button("Elegir de la Galería") {
                showPhotoGallery = true // Activa .photosPicker
            }
            Button("Tomar Foto") {
                print("Cámara no Implementada aún...")
            }
            Button("Cancelar", role: .cancel) {}
        }
        .photosPicker(isPresented: $showPhotoGallery, selection: $selectedPhotoItem, matching: .images)
        .onChange(of: selectedPhotoItem) {_, newItem in
            // Tarea para procesar la imagen seleccionada
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    self.profileImageData = data // Guarda Data
                    if let uiImage = UIImage(data: data) {
                        self.profileImage = Image(uiImage: uiImage) // Mostrar Imagen
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
                        .foregroundStyle(Color.blue.opacity(0.9))
                    
                    if editable {
                        TextField("", text: $text)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)
                    } else {
                        Text(text)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(editable ? Color.blue.opacity(0.1) : Color(.systemGray5))
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
                        .foregroundStyle(Color.blue.opacity(0.9))
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
                    .fill(editable ? Color.blue.opacity(0.1) : Color(.systemGray5))
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

// Chip para Números Int
struct IntChipRow: View {
    let titulo: String
    @Binding var value: Int
    var editable: Bool = false
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                HStack(spacing: 2) {
                    Text(titulo)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.blue.opacity(0.9))
                    
                    if editable {
                        TextField("", value: $value, format: .number)
                            .textFieldStyle(.plain)
                            .autocorrectionDisabled(true)
                            .keyboardType(.numberPad) // Teclado numérico
                    } else {
                        Text(value, format: .number)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(editable ? Color.blue.opacity(0.1) : Color(.systemGray5))
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
                        .foregroundStyle(Color.blue.opacity(0.9))
                    
                    if editable {
                        Picker(titulo, selection: $selection) {
                            ForEach(options, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(.menu) // Estilo de menú desplegable
                        .tint(.primary) // Para que el texto no sea azul
                        
                    } else {
                        Text(selection) // Solo muestra el texto
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(editable ? Color.blue.opacity(0.1) : Color(.systemGray5))
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
                        .foregroundStyle(Color.blue.opacity(0.9))
                    
                    Spacer() // Empuja el picker a la derecha
                    
                    if editable {
                        DatePicker(
                            "",
                            selection: $selection,
                            in: ...Date(), // No permite fechas futuras
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .tint(.blue)
                    } else {
                        Text(selection, style: .date)
                    }
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule()
                    .fill(editable ? Color.blue.opacity(0.1) : Color(.systemGray5))
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
