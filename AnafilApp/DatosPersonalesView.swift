//
//  DatosPersonalesView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 17/09/25.
//

import SwiftUI
import SwiftData

struct DatosPersonalesView: View {
    @State private var isEditing: Bool = false
    @State private var showSaveConfirmation: Bool = false // Retro al Usuario
    @Query(sort: \User.nombre) var users: [User] // Cargar Usuario
    var currentUser: User? { users.first }
    
    private func saveChanges() {
        isEditing = false
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
                    NavigationLink{
                        BotiquinView()
                    } label: {
                        Image(systemName: "cross.case")
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
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.gray.opacity(0.7))
                        .padding(6)
                }
                .frame(width: 56, height: 56)

                Text(currentUser?.nombre ?? "Usuario no encontrado")
                    .font(.title3.weight(.semibold))
                Spacer()
                
                Button {
                    if isEditing {
                        withAnimation{ showSaveConfirmation = true } // Mostrar confirmación
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showSaveConfirmation = false }
                    }
                    isEditing.toggle()
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
                if let user = currentUser { // Usamos Bingings para la edición en @Binable var user = users
                    @Bindable var user = user
                    // Opciones de Tipos de Sangre
                    let bloodTypes = ["N/A", "O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"]
                    let sexOptions = ["No Especificado","Hombre", "Mujer"]
                    
                    VStack(spacing: 14) {
                        ChipRow(titulo: "Nombre:", text: $user.nombre, editable: isEditing)
                        ChipRow(titulo: "Apellidos:", text: $user.apellidos, editable: isEditing)
                        ChipRow(titulo: "Teléfono:", text: $user.telefono, editable: isEditing)
                        ChipRow(titulo: "Contacto Emergencias:", text: $user.contactoEmergencia, editable: isEditing)
                        ChipRow(titulo: "Dirección:", text: $user.direccion, editable: isEditing)
                        PickerChipRow(titulo: "Sexo:", selection: $user.sexo, options: sexOptions, editable: isEditing)
                        DoubleChipRow(titulo: "Peso (Kg):", value: $user.peso, editable: isEditing)
                        IntChipRow(titulo: "Edad:", value: $user.edad, editable: isEditing)
                        PickerChipRow(titulo: "Tipo de sangre:", selection: $user.tipoSangre, options: bloodTypes, editable: isEditing)
                        ChipRow(titulo: "Diagnóstico:", text: $user.diagnostico, editable: isEditing)
                        ChipRow(titulo: "Alergias:", text: $user.alergias, editable: isEditing)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
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
                    NotificacionesView()
                } label: {
                    Image(systemName: "bell.fill")
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
    }
}

// Estructura Chip
struct ChipRow: View {
    let titulo: String
    var editable: Bool = false
    @Binding var text: String

    init(titulo: String, text: Binding<String>, editable: Bool = false) {
        self.titulo = titulo
        self._text = text
        self.editable = editable
    }
    
    var body: some View {
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
                .fill(Color(.systemGray5))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }
}

// Chip para Números Double
struct DoubleChipRow: View {
    let titulo: String
    @Binding var value: Double
    var editable: Bool = false
    private var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2 // 2 decimales
        return f
    }

    var body: some View {
        HStack {
            HStack(spacing: 2) {
                Text(titulo)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.blue.opacity(0.9))
                if editable {
                    TextField("", value: $value, formatter: formatter)
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
                .fill(Color(.systemGray5))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }
}

// Chip para Números Int
struct IntChipRow: View {
    let titulo: String
    @Binding var value: Int
    var editable: Bool = false
    private var formatter: NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .none // Sin decimales
        return f
    }

    var body: some View {
        HStack {
            HStack(spacing: 2) {
                Text(titulo)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.blue.opacity(0.9))
            
                if editable {
                    TextField("", value: $value, formatter: formatter)
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
                .fill(Color(.systemGray5))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }
}

// Chip con Picker (String)
struct PickerChipRow: View {
    let titulo: String
    @Binding var selection: String
    var options: [String]
    var editable: Bool = false

    var body: some View {
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
            
            if editable {
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color(.systemGray5))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }
}

#Preview {
    NavigationStack { DatosPersonalesView() }
}
