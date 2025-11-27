//
//  Botiquin1View.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 21/09/25.
//

import SwiftUI
import SwiftData
import PhotosUI

struct BotiquinView: View {
    @Query(sort: \User.nombre) var users: [User]
    var currentUser: User? {users.first}
    
    var isEnglish: Bool { currentUser?.idiomaSeleccionado == "English" }
    
    @Environment(\.modelContext) private var modelContext
    
    // Estados recetas
    @State private var newRecetaDate: Date = Date()
    @State private var newRecetaImage: Image?
    @State private var newRecetaImageData: Data?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showPhotoGallery: Bool = false
    
    // Estados Adrenalina
    @State private var showAddAdrenalina: Bool = false // Modal o toggle
    @State private var newAdrenalinaDate: Date = Date()
    
    // Feedback y Errores
    @State private var error: String?
    @State private var showSaveConfirmation: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    @State private var itemDeletedMessage: String = ""
    
    // Estados para Deshacer Recetas
    @State private var recetaParaBorrar: RecetaMedica?
    @State private var adrenalinaParaBorrar: Adrenalina?
    @State private var deleteTimer: Timer?
    
    private func saveAdrenalina() {
        guard let user = currentUser else { return }
        
        // Borrar anterior si existe (asumimos que el usuario reemplaza su adrenalina)
        if let oldAdrenalina = user.adrenalinas.first {
            NotificationManager.shared.cancelNotifications(for: oldAdrenalina)
            modelContext.delete(oldAdrenalina)
        }
        
        let nuevaAdrenalina = Adrenalina(fechaCaducidad: newAdrenalinaDate)
        user.adrenalinas.append(nuevaAdrenalina)
        
        // Programar notificaciones
        NotificationManager.shared.scheduleAdrenalineNotifications(for: nuevaAdrenalina, isEnglish: isEnglish)
        
        showAddAdrenalina = false
        withAnimation {
            showSaveConfirmation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { showSaveConfirmation = false } }
    }
    
    private func deleteAdrenalina(_ adrenalina: Adrenalina) {
            // Si había una receta pendiente de borrar, bórrala ya para dar paso a esta acción
            performActualDelete()
            deleteTimer?.invalidate()
            withAnimation {
                showSaveConfirmation = false
                adrenalinaParaBorrar = adrenalina // Guardado temporal
                itemDeletedMessage = isEnglish ? "Adrenaline removed." : "Adrenalina eliminada."
                showDeleteConfirmation = true // Mostramos el Toast con botón Deshacer
            }
            // Iniciamos el temporizador de 3 segundos
            deleteTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                performActualDelete()
            }
        }
    
    // Funciones Recetas
    private func saveReceta() {
        error = nil
        guard let data = newRecetaImageData else {
            error = isEnglish ? "Please upload an image of the prescription." : "Por favor, sube una imagen de la receta."
            return
        }
        guard let user = currentUser else { return }
        
        let newReceta = RecetaMedica(fechaSubida: newRecetaDate, imagenRecetaData: data)
        user.recetas.append(newReceta)
        
        newRecetaDate = Date()
        newRecetaImage = nil
        newRecetaImageData = nil
        selectedPhotoItem = nil
        
        withAnimation { showSaveConfirmation = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { showSaveConfirmation = false } }
    }
    
    private func deleteReceta(receta: RecetaMedica) {
        deleteTimer?.invalidate()
        withAnimation {
            showSaveConfirmation = false
            recetaParaBorrar = receta
            itemDeletedMessage = isEnglish ? "Prescription deleted." : "Receta eliminada."
            showDeleteConfirmation = true
        }
        deleteTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            performActualDelete()
        }
    }
    
    // EEjecutadora para ambos casos
    private func performActualDelete() {
        // Caso Receta
        if let receta = recetaParaBorrar {
            modelContext.delete(receta)
            recetaParaBorrar = nil
        }
        // Caso Adrenalina
        if let adrenalina = adrenalinaParaBorrar {
            NotificationManager.shared.cancelNotifications(for: adrenalina)
            modelContext.delete(adrenalina)
            adrenalinaParaBorrar = nil
        }
        withAnimation { showDeleteConfirmation = false }
        deleteTimer = nil
    }
    
    private func undoDelete() {
            deleteTimer?.invalidate()
            withAnimation { showDeleteConfirmation = false }
            recetaParaBorrar = nil
            adrenalinaParaBorrar = nil
            deleteTimer = nil
        }
    
    private var sortedRecetas: [RecetaMedica] {
        let allRecetas = currentUser?.recetas.sorted(by: { $0.fechaSubida > $1.fechaSubida }) ?? []
        if let recetaParaBorrar = recetaParaBorrar {
            return allRecetas.filter { $0.id != recetaParaBorrar.id }
        }
        return allRecetas
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    let userName = currentUser?.nombre ?? (isEnglish ? "User" : "Usuario")
                    Label {
                        Text(isEnglish ? "First Aid Kit of \(userName)" : "Botiquín de \(userName)")
                    } icon: {
                        Image(systemName: "cross.case")
                            .foregroundStyle(Color.cmicaBlue)
                    }
                    .font(.title3.weight(.semibold))
                    
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
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            
                            // Secc 1: Adrenalina
                            VStack(alignment: .leading, spacing: 12) {
                                Text(isEnglish ? "Adrenaline" : " Adrenalina")
                                    .font(.headline).fontWeight(.semibold)
                                    .foregroundStyle(Color.cmicaBlue)
                                
                                if let adrenalina = currentUser?.adrenalinas.first, adrenalina.id != adrenalinaParaBorrar?.id {
                                    // Tarjeta de Adrenalina Existente
                                    AdrenalinaCard(adrenalina: adrenalina, isEnglish: isEnglish) {
                                        deleteAdrenalina(adrenalina)
                                    }
                                } else {
                                    // Botón para agregar si no hay
                                    if showAddAdrenalina {
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(isEnglish ? "Expiration Date:" : "Fecha de Caducidad:")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                            
                                            DatePicker("", selection: $newAdrenalinaDate, displayedComponents: .date)
                                                .labelsHidden()
                                                .datePickerStyle(.compact)
                                                .tint(Color.cmicaBlue)
                                            
                                            HStack {
                                                Button(isEnglish ? "Cancel" : "Cancelar") {
                                                    withAnimation { showAddAdrenalina = false }
                                                }
                                                .foregroundStyle(.red)
                                                
                                                Spacer()
                                                
                                                Button(isEnglish ? "Save" : "Guardar") {
                                                    saveAdrenalina()
                                                }
                                                .buttonStyle(.borderedProminent)
                                                .tint(Color.cmicaBlue)
                                            }
                                            .padding(.top, 4)
                                        }
                                        .padding()
                                        .background(Color(.systemBackground))
                                        .cornerRadius(12)
                                        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                                        
                                    } else {
                                        Button(action: {
                                            newAdrenalinaDate = Date() // Reset fecha
                                            withAnimation { showAddAdrenalina = true }
                                        }) {
                                            HStack {
                                                Image(systemName: "plus.circle.fill")
                                                Text(isEnglish ? "Register Adrenaline" : "Registrar Adrenalina")
                                            }
                                            .fontWeight(.semibold)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.cmicaBlue.opacity(0.1))
                                            .foregroundColor(Color.cmicaBlue)
                                            .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // Secc 2: Recetas
                            VStack(alignment: .leading, spacing: 12) {
                                Text(isEnglish ? "Add Medical Prescription" : "Agregar Receta Médica")
                                    .font(.headline).fontWeight(.semibold)
                                    .foregroundStyle(Color.cmicaBlue)
                                
                                // Botón para subir Receta (PhotosPicker)
                                Button(action: { showPhotoGallery = true }) {
                                    HStack {
                                        if let newRecetaImage {
                                            newRecetaImage
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 100)
                                                .clipped()
                                        } else {
                                            Text(isEnglish ? "Upload Prescription" : "Subir Receta")
                                                .foregroundStyle(.secondary)
                                            Spacer()
                                            Image(systemName: "arrow.up.circle")
                                                .font(.title2)
                                                .foregroundStyle(Color.cmicaBlue)
                                        }
                                    }
                                    .padding()
                                    .frame(height: newRecetaImage != nil ? 100 : 50)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                                
                                // Selector de Fecha Receta
                                DatePicker(isEnglish ? "Date" : "Fecha", selection: $newRecetaDate, in: ...Date(), displayedComponents: .date)
                                    .tint(Color.cmicaBlue)
                                
                                if let error = error {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                
                                Button(isEnglish ? "Add Prescription" : "Agregar Receta", action: saveReceta)
                                    .buttonStyle(.borderedProminent)
                                    .tint(Color.cmicaBlue)
                                    .frame(maxWidth: .infinity)
                            }
                            .cardStyle()
                            
                            // LISTA DE RECETAS
                            VStack(alignment: .leading, spacing: 12) {
                                Text(isEnglish ? "My Saved Prescriptions" : "Mis Recetas Guardadas")
                                    .font(.headline).fontWeight(.semibold)
                                    .foregroundStyle(Color.cmicaBlue)
                                
                                if !sortedRecetas.isEmpty {
                                    ForEach(sortedRecetas, id: \.id) { receta in
                                        RecetaCardView(receta: receta, isEnglish: isEnglish, onDelete: {
                                            deleteReceta(receta: receta)
                                        })
                                        .transition(.opacity.combined(with: .scale))
                                    }
                                } else {
                                    Text(currentUser?.recetas.isEmpty ?? true ? (isEnglish ? "You don't have saved prescriptions yet." : "Aún no tienes Recetas guardadas.") : "...")
                                        .foregroundStyle(.secondary)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                }
                            }
                            .cardStyle()
                            .animation(.default, value: sortedRecetas)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.vertical, 12)
                    }
                    .background(Color(.systemGroupedBackground))
                }
                
                // Alertas (Toasts)
                VStack(spacing: 8) {
                    if showSaveConfirmation {
                        Text(isEnglish ? "Saved successfully!" : "¡Guardado con éxito!")
                            .font(.caption.weight(.semibold))
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(Color.green)
                            .cornerRadius(8)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .zIndex(1)
                    }
                    if showDeleteConfirmation {
                        HStack{
                            Text(itemDeletedMessage)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.red)
                            Spacer()
                            // El deshacer solo funciona para recetas en esta lógica simple
                            if deleteTimer != nil {
                                Button(isEnglish ? "Undo" : "Deshacer") {
                                    undoDelete()
                                }
                                .font(.caption.weight(.bold))
                                .tint(Color.red)
                            }
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                
                // Tab bar
                Spacer(minLength: 0)
                MenuInferior(activeTab: "botiquin")
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            
            .photosPicker(isPresented: $showPhotoGallery, selection: $selectedPhotoItem, matching: .images)
            .onChange(of: selectedPhotoItem) {_, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        self.newRecetaImageData = data
                        if let uiImage = UIImage(data: data) {
                            self.newRecetaImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
        }
    }
}

// Componente visual de la tarjeta de Adrenalina
struct AdrenalinaCard: View {
    let adrenalina: Adrenalina
    let isEnglish: Bool
    let onDelete: () -> Void
    
    var colorEstado: Color {
        switch adrenalina.estado {
        case .vigente: return .green
        case .porCaducar: return .orange
        case .caducada: return .red
        }
    }
    
    var textoEstado: String {
        switch adrenalina.estado {
        case .vigente: return isEnglish ? "Valid" : "Vigente"
        case .porCaducar: return isEnglish ? "Expiring Soon" : "Por Caducar"
        case .caducada: return isEnglish ? "Expired" : "Caducada"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(isEnglish ? "Expiration Date:" : "Fecha de Caducidad:")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(adrenalina.fechaCaducidad.formatted(date: .long, time: .omitted))
                    .font(.title3.bold())
                    .foregroundStyle(Color.primary)
                
                HStack {
                    Image(systemName: adrenalina.estado == .vigente ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    Text(textoEstado)
                }
                .font(.caption.bold())
                .foregroundStyle(colorEstado)
                .padding(.top, 2)
            }
            
            Spacer()
            
            // Botón Borrar
            Button(action: onDelete) {
                Image(systemName: "trash.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(Color.gray.opacity(0.3))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        // Borde de color según estado
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorEstado.opacity(0.5), lineWidth: 2)
        )
        .cornerRadius(12)
        .shadow(color: colorEstado.opacity(0.1), radius: 5, y: 2)
    }
}

struct RecetaCardView: View {
    let receta: RecetaMedica
    var isEnglish: Bool
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                InfoRow(isEnglish ? "Date Uploaded: " : "Fecha Subida: ", receta.fechaSubida.formatted(date: .long, time: .omitted))
                if let data = receta.imagenRecetaData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .bottom, .trailing])
            .padding(.top, 40)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            Button(role: .destructive, action: onDelete) {
                Image(systemName: "trash.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
                    .background(Circle().fill(Color.white))
            }
            .padding(8)
        }
    }
}

private struct InfoRow: View {
    let left: String, right: String
    var accent: Color? = nil
    init(_ left: String, _ right: String, accent: Color? = nil) {
        self.left = left; self.right = right; self.accent = accent
    }
    var body: some View {
        HStack {
            Text(left).font(.subheadline)
            Spacer()
            Text(right).font(.subheadline)
                .foregroundStyle(accent ?? .primary)
        }
    }
}

private extension View {
    func cardStyle() -> some View {
        self.padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
    }
}
