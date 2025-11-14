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
    
    // Acceso a Usuario para Idioma
    @Query(sort: \User.nombre) var users: [User]
    var currentUser: User? { users.first }
    var isEnglish: Bool { currentUser?.idiomaSeleccionado == "English" }

    
    var body: some View {
        VStack(spacing: 0) {
            // 1. HEADER
            HStack {
                Text("AnafilApp")
                    .font(.title3).bold()
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
                Map(position: .constant(.region(locationManager.region))) {
                    // Tu posición
                    Annotation(isEnglish ? "Me" : "Yo", coordinate: locationManager.region.center) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                            .background(Circle().fill(.white))
                            .clipShape(Circle())
                    }
                    
                    // Pines de Hospitales
                    ForEach(locationManager.hospitals, id: \.self) { item in
                        Marker(item.name ?? "Hospital", systemImage: "cross.fill", coordinate: item.placemark.coordinate)
                            .tint(.red)
                    }
                }
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Botón para recentrar
                Button(action: {
                    locationManager.manager.startUpdatingLocation()
                }) {
                    Image(systemName: "location.fill")
                        .padding(10)
                        .background(Color(.systemBackground))
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // Aviso Legal
            Text(isEnglish
                ? "Disclaimer: Results are location-based suggestions. We are not responsible for service availability."
                : "Aviso: Los resultados son sugerencias por ubicación. No nos hacemos responsables de la disponibilidad del servicio.")
                .font(.caption2) // Letra pequeña
                .foregroundColor(.red) // Color rojo
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 8)
            
            Spacer().frame(height: 2)
            
            // 3. LISTA DE HOSPITALES
            VStack(alignment: .leading, spacing: 12) {
                Text(isEnglish ? "Nearest Hospitals" : "Hospitales más cercanos")
                    .font(.headline)
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
            
            // 4. MENÚ INFERIOR
            Spacer(minLength: 0)
            MenuInferior(activeTab: "home")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// Componente de Fila Dinámico (Sin botón de ir)
struct HospitalRow: View {
    let item: MKMapItem
    var isEnglish: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono de Hospital
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: "cross.case.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            
            // Info del Hospital
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name ?? (isEnglish ? "Unknown Hospital" : "Hospital Desconocido"))
                    .font(.subheadline).fontWeight(.semibold)
                    .lineLimit(1)
                
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
