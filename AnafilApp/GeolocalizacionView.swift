//
//  GeolocalizacionView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 10/09/25.
//

import SwiftUI
import MapKit
import _MapKit_SwiftUI

struct GeolocalizacionView: View {
    @State private var locationManager = LocationManager() // Iniciar el Manager
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("AnafilApp")
                    .font(.title3).bold()
                Spacer()
                HStack(spacing: 14) {
                    NotificacionesBellView()
                    Image(systemName: "globe")
                }
                .font(.title3)
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Spacer().frame(height: 16)
            
            // Mapa
            ZStack(alignment: .topTrailing) {
                Map(position: .constant(.region(locationManager.region))) {
                    // Tu posición
                    Annotation("Yo", coordinate: locationManager.region.center) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                            .background(Circle().fill(.white))
                    }
                    // Pines de Hospitales
                    ForEach(locationManager.hospitals, id: \.self) {item in
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
            
            Spacer().frame(height: 20)
            
            // Lista de Hospitales
            VStack(alignment: .leading, spacing: 12) {
                Text("Hospitales más cercanos")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Mostramos sólo los 3 primeros
                        ForEach(locationManager.hospitals.prefix(3), id: \.self) { item in
                            HospitalRow(item: item)
                        }
                        if locationManager.hospitals.isEmpty {
                            Text("Buscando hospitales...")
                                .foregroundStyle(.secondary)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            // Menú Inferior
            Spacer(minLength: 0)
            MenuInferior(activeTab: "home")
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct HospitalRow: View {
    let item: MKMapItem
    
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
                Text(item.name ?? "Hospital Desconocido")
                    .font(.subheadline).fontWeight(.semibold)
                    .lineLimit(1)
                
                // Categoría o Dirección
                Text(item.placemark.title ?? "Dirección no disponible")
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
