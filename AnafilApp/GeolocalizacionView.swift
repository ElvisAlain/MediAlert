//
//  GeolocalizacionView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI
import MapKit
import SwiftData

struct GeolocalizacionView: View {
    @State private var locationManager = LocationManager()
    
    // Control de la cámara
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    // Control para hacer el zoom automático SOLO la primera vez
    @State private var hasInitialZoomHappened = false
    
    @Query(sort: \User.nombre) var users: [User]
    var currentUser: User? { users.first }
    var isEnglish: Bool { currentUser?.idiomaSeleccionado == "English" }

    var body: some View {
        VStack(spacing: 0) {
            // 1. HEADER
            HStack {
                Text("AnafilApp")
                    .font(.title3).bold()
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
            
            // 2. MAPA
            ZStack(alignment: .topTrailing) {
                Map(position: $cameraPosition) {
                    // Tu posición
                    if let userLocation = locationManager.userLocation {
                         Annotation(isEnglish ? "Me" : "Yo", coordinate: userLocation.coordinate) {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(Color.cmicaBlue)
                                .font(.title)
                                .background(Circle().fill(.white))
                                .clipShape(Circle())
                        }
                    }
                    
                    ForEach(locationManager.hospitals, id: \.self) { item in
                        Marker(item.name ?? "Hospital", systemImage: "cross.fill", coordinate: item.placemark.coordinate)
                            .tint(.red)
                    }
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                // DETECTAR CUANDO LLEGAN LOS HOSPITALES PARA HACER ZOOM AUTOMÁTICO
                .onChange(of: locationManager.hospitals) { _, newHospitals in
                    if !hasInitialZoomHappened && !newHospitals.isEmpty {
                        enfocarAreaInteligente()
                        hasInitialZoomHappened = true
                    }
                }

                // Botón para recentrar (Zoom Inteligente)
                Button(action: {
                    enfocarAreaInteligente()
                }) {
                    Image(systemName: "location.fill")
                        .padding(10)
                        .background(Color(.systemBackground))
                        .foregroundStyle(Color.cmicaBlue)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Aviso
            Text(isEnglish
                ? "Disclaimer: Results are location-based suggestions. We are not responsible for service availability."
                : "Aviso: Los resultados son sugerencias por ubicación. No nos hacemos responsables de la disponibilidad del servicio.")
                .font(.caption2)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            Spacer().frame(height: 2)
            
            // 3. LISTA DE HOSPITALES
            VStack(alignment: .leading, spacing: 12) {
                Text(isEnglish ? "Nearest Hospitals" : "Hospitales más cercanos")
                    .font(.headline)
                    .foregroundStyle(Color.cmicaBlue)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 16) {
                        if !locationManager.hospitals.isEmpty {
                            ForEach(locationManager.hospitals.prefix(3), id: \.self) { item in
                                HospitalRow(item: item, isEnglish: isEnglish)
                            }
                        } else {
                            ContentUnavailableView(
                                isEnglish ? "Searching for hospitals..." : "Buscando hospitales...",
                                systemImage: "location.magnifyingglass",
                                description: Text(isEnglish ? "Make sure to grant location permissions." : "Asegúrate de dar permisos de ubicación.")
                            )
                            .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            
            Spacer(minLength: 0)
            MenuInferior(activeTab: "home")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    // Zoom Inteligente
    private func enfocarAreaInteligente() {
        guard let userLoc = locationManager.userLocation else { return }
        
        // Si no hay hospitales, solo zoom al usuario (cercano)
        if locationManager.hospitals.isEmpty {
            withAnimation {
                cameraPosition = .region(MKCoordinateRegion(
                    center: userLoc.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
            }
            return
        }
        
        // Si HAY hospitales, tomamos al usuario y a los 3 primeros
        var coordenadas = [userLoc.coordinate]
        let top3 = locationManager.hospitals.prefix(3)
        coordenadas.append(contentsOf: top3.map { $0.placemark.coordinate })
        
        // Calcular límites (Bounding Box)
        let minLat = coordenadas.map { $0.latitude }.min() ?? userLoc.coordinate.latitude
        let maxLat = coordenadas.map { $0.latitude }.max() ?? userLoc.coordinate.latitude
        let minLon = coordenadas.map { $0.longitude }.min() ?? userLoc.coordinate.longitude
        let maxLon = coordenadas.map { $0.longitude }.max() ?? userLoc.coordinate.longitude
        
        let centro = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        
        // Calcular el span (distancia) y agregar un margen (x1.4) para que no queden pegados al borde
        let spanLat = (maxLat - minLat) * 1.4
        let spanLon = (maxLon - minLon) * 1.4
        
        // Evitar que el zoom sea DEMASIADO cerca si todo está junto (mínimo 0.01)
        let finalSpan = MKCoordinateSpan(
            latitudeDelta: max(spanLat, 0.01),
            longitudeDelta: max(spanLon, 0.01)
        )
        
        // Aplicar la cámara
        withAnimation {
            cameraPosition = .region(MKCoordinateRegion(center: centro, span: finalSpan))
        }
    }
}

// Componente de Fila Dinámico
struct HospitalRow: View {
    let item: MKMapItem
    var isEnglish: Bool
    
    // Función para abrir Apple Maps con la ruta
    private func abrirMapas() {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving] // Modo Driving
        item.openInMaps(launchOptions: launchOptions)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono de Hospital
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cmicaBlue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "cross.case.fill")
                    .font(.title2)
                    .foregroundColor(Color.cmicaBlue)
            }
            
            // Info del Hospital
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name ?? (isEnglish ? "Unknown Hospital" : "Hospital Desconocido"))
                    .font(.subheadline).fontWeight(.semibold)
                    .lineLimit(2)
                
                // Dirección
                Text(item.placemark.title ?? (isEnglish ? "Location not available" : "Dirección no disponible"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Teléfono (si tiene)
                if let phone = item.phoneNumber {
                    Text(phone)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Botón de Ruta
            Button(action: {
                abrirMapas()
            }) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.title2)
                    .foregroundColor(Color.cmicaBlue)
                    .padding(8)
                    .contentShape(Rectangle())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
        )
    }
}
#Preview {
    GeolocalizacionView()
        .modelContainer(for: User.self, inMemory: true)
}
