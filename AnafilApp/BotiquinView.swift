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
    
    // Estados para las Recetas
    @State private var newRecetaDate: Date = Date()
    @State private var newRecetaImage: Image?
    @State private var newRecetaImageData: Data?
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showPhotoGallery: Bool = false
    @State private var error: String?
    
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
                        NavigationLink{ NotificacionesView() } label: {
                            Image(systemName: "bell.fill")
                        }
                        Image(systemName: currentUser?.idiomaSeleccionado == "Español" ? "globe" : "globe.fill")
                    }
                    .font(.title3)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // Botiquin2Page()
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
                        
                        // Card: Imagen + Fecha (mock)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Mis Recetas Guardadas")
                                .font(.headline).fontWeight(.semibold)
                            
                            if let recetas = currentUser?.recetas, !recetas.isEmpty {
                                // Iterar sobre las recetas guardadas
                                ForEach(recetas.sorted(by: { $0.fechaSubida > $1.fechaSubida })) {receta in
                                    VStack(alignment: .leading) {
                                        InfoRow("Fecha Subida: ", receta.fechaSubida.formatted(date: .long, time: .omitted))
                                        if let data = receta.imagenRecetaData, let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                        }
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                }
                            } else {
                                Text("Aún no tienes Recetas guardadas.")
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            }
                        }
                        .cardStyle()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemGroupedBackground))
                
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
