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
    @Query(sort: \User.nombre) var users: [User] // Conexión a SwiftData
    var currentUser: User? {users.first}
    
    @Environment(\.modelContext) private var modelContext // Para poder borrar Recetas
    // Estados para las Recetas
    @State private var newRecetaDate: Date = Date()
    @State private var newRecetaImage: Image?
    @State private var newRecetaImageData: Data?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showPhotoGallery: Bool = false
    @State private var error: String?
    @State private var showSaveConfirmation: Bool = false // Para dar retro al User
    
    // Estados para Deshacer
    @State private var showDeleteConfirmation: Bool = false // Deshacer
    @State private var recetaParaBorrar: RecetaMedica? // La que está en espera
    @State private var deleteTimer: Timer? // Temporizador
    
    // Función para Guardar Receta
    private func saveReceta() {
        error = nil // Limpiar Error
        
        guard let data = newRecetaImageData else { // Validar que haya una imagen
            error = "Por favor, sube una imagen de la receta."
            return
        }
        guard let user = currentUser else { // Obtener el Usuario
            error = "No se pudo encontrar el usuario."
            return
        }
        let newReceta = RecetaMedica(fechaSubida: newRecetaDate, imagenRecetaData: data)
        user.recetas.append(newReceta) // SwiftData sube el cambio
        
        // Limpiar campos
        newRecetaDate = Date()
        newRecetaImage = nil
        newRecetaImageData = nil
        selectedPhotoItem = nil
        
        // Mostrar confirmación
        withAnimation {
            showSaveConfirmation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showSaveConfirmation = false
            }
        }
    }
    private func deleteReceta(receta: RecetaMedica) { // El usuario pulsa Borrar
        deleteTimer?.invalidate()
        withAnimation {
            showSaveConfirmation = false
            recetaParaBorrar = receta
            showDeleteConfirmation = true
        }
        deleteTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in // Timer de 3seg | Si no se cancela, se borra de verdad
            performActualDelete()
        }
    }
    private func performActualDelete() { // El timer se acaba y se bora definitivamente
        if let receta = recetaParaBorrar {
            modelContext.delete(receta)
        }
        withAnimation { showDeleteConfirmation = false }
        recetaParaBorrar = nil
        deleteTimer = nil
    }
    private func undoDelete() { // El usuario pulsa 'Deshacer'
        deleteTimer?.invalidate()
        withAnimation { showDeleteConfirmation = false }
        recetaParaBorrar = nil
        deleteTimer = nil
    }
    private var sortedRecetas: [RecetaMedica] { // Precalcular la lista ordenada
        let allRecetas = currentUser?.recetas.sorted(by: { $0.fechaSubida > $1.fechaSubida }) ?? []
        if let recetaParaBorrar = recetaParaBorrar { // Si hay uno para borrar, no se muestra
            return allRecetas.filter { $0.id != recetaParaBorrar.id }
        }
        return allRecetas
    }
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Label("Botiquín de \(currentUser?.nombre ?? "Usuario")", systemImage: "cross.case")
                        .font(.title3.weight(.semibold))
                    Spacer()
                    HStack(spacing: 14) {
                        NotificacionesBellView()
                        Image(systemName: currentUser?.idiomaSeleccionado == "Español" ? "globe" : "globe.fill")
                    }
                    .font(.title3)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 8)
                
                ZStack(alignment: .top) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            // Card: Agregar Receta Médica
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Agregar Receta Médica")
                                    .font(.headline).fontWeight(.semibold)
                                
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
                                            Text("Subir Receta")
                                                .foregroundStyle(.secondary)
                                            Spacer()
                                            Image(systemName: "arrow.up.circle")
                                        }
                                    }
                                    .padding()
                                    .frame(height: newRecetaImage != nil ? 100 : 50)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                                
                                // Selector de Fecha
                                DatePicker("Fecha", selection: $newRecetaDate, in: ...Date(), displayedComponents: .date)
                                
                                // Mostrar Error si hay
                                if let error = error {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                
                                Button("Agregar", action: saveReceta)
                                    .buttonStyle(.borderedProminent)
                                    .frame(maxWidth: .infinity)
                            }
                            .cardStyle()
                            
                            // Card: Mis Recetas Guardadas
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Mis Recetas Guardadas")
                                    .font(.headline).fontWeight(.semibold)
                                
                                if !sortedRecetas.isEmpty {
                                    ForEach(sortedRecetas, id: \.id) { receta in
                                        // Usamos la nueva vista 'RecetaCardView'
                                        RecetaCardView(receta: receta, onDelete: {
                                            deleteReceta(receta: receta)
                                        })
                                        .transition(.opacity.combined(with: .scale))
                                    }
                                } else {
                                    Text(currentUser?.recetas.isEmpty ?? true ? "Aún no tienes Recetas guardadas." : "...")
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
                
                VStack(spacing: 8) {
                    // Mensaje de Confirmación
                    if showSaveConfirmation {
                        Text("¡Receta guardada con éxito!")
                            .font(.caption.weight(.semibold))
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(Color.green)
                            .cornerRadius(8)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .zIndex(1) // Al frente
                    }
                    if showDeleteConfirmation {
                        HStack{
                            Text("Receta eliminada.")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(Color.red)
                            Spacer()
                            Button("Deshacer") {
                                undoDelete()
                            }
                            .font(.caption.weight(.bold))
                            .tint(Color.red)
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
                HStack(spacing: 30) {
                    NavigationLink { GeolocalizacionView() } label: {
                        Image(systemName: "house.fill")
                    }
                    Image(systemName: "cross.case.fill")
                    ZStack {
                        Circle().fill(Color(.systemBackground))
                            .frame(width: 56, height: 56)
                            .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                        Text("SOS").font(.headline)
                    }
                    NavigationLink {GuiasView()} label: {Image(systemName: "book.fill")}
                    NavigationLink { DatosPersonalesView() } label: {
                        Image(systemName: "person.crop.circle.fill")
                    }
                }
                .font(.title2)
                .padding(.vertical, 10)
                .background(Color.clear)
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
    
struct RecetaCardView: View {
    let receta: RecetaMedica
    let onDelete: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading) {
                InfoRow("Fecha Subida: ", receta.fechaSubida.formatted(date: .long, time: .omitted))
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

private struct LabeledField: View {
    let label: String
    init(_ label: String) { self.label = label }
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.subheadline)
            TextField("", text: .constant(""))
                .textFieldStyle(.roundedBorder)
                .frame(height: 36)
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

#Preview {
    BotiquinView()
        .modelContainer(for: [User.self, RecetaMedica.self], inMemory: true)
}
