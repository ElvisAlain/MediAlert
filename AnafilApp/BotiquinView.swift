//
//  Botiquin1View.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 21/09/25.
//

import SwiftUI

struct BotiquinView: View {
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Label("Botiquín de Camila", systemImage: "cross.case")
                        .font(.title3.weight(.semibold))
                    Spacer()
                    Image(systemName: "globe")
                        .font(.title3)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Botiquin2Page()
                
                // Tab bar
                HStack(spacing: 30) {
                    NavigationLink { GeolocalizacionView() } label: {
                        Image(systemName: "house.fill")
                    }
                    NavigationLink { NotificacionesView() } label: {
                        Image(systemName: "bell.fill")
                    }
                    ZStack {
                        Circle().fill(Color(.systemBackground))
                            .frame(width: 56, height: 56)
                            .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                        Text("SOS").font(.headline)
                    }
                    NavigationLink {GuiasView()} label: {Image(systemName: "book.fill")}
                    // Image(systemName: "book.fill")
                    NavigationLink { DatosPersonalesView() } label: {
                        Image(systemName: "person.crop.circle.fill")
                    }
                }
                .font(.title2)
                .padding(.vertical, 10)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// Por solicitud de CMICA, se eliminará esta primera pagina y a su vez el Swipe, ya que la App va únicamente dirigida a Anafilexia, por lo tanto solo a Adrenalina
/*
private struct Botiquin1Page: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Card: Agregar Medicamento
                VStack(alignment: .leading, spacing: 12) {
                    Text("Agregar Medicamento")
                        .font(.headline).fontWeight(.semibold)
                    
                    LabeledField("Nombre:")
                    LabeledField("Dosis:")
                    LabeledField("Cada cuánto:")
                    LabeledField("Durante:")
                    LabeledField("Fecha de Caducidad:")
                    
                    Button(action: {}) {
                        Text("Agregar")
                            .font(.headline).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 12)
                            .background(Color.blue).cornerRadius(8)
                    }
                    .padding(.top, 4)
                }
                .cardStyle()
                
                // Card: Medicamentos (prueba)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Medicamentos")
                        .font(.headline).fontWeight(.semibold)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Adrenalina")
                            .font(.headline).fontWeight(.bold)
                        InfoRow("Dosis", "5 mg")
                        InfoRow("Cada cuánto:", "Cada 8 hrs")
                        InfoRow("Durante", "5 días")
                        InfoRow("Fecha de Caducidad:", "30/08/2025", accent: .red)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .cardStyle()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
    }
}
*/
private struct Botiquin2Page: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Card: Agregar Receta Médica
                VStack(alignment: .leading, spacing: 12) {
                    Text("Agregar Receta Médica")
                        .font(.headline).fontWeight(.semibold)
                    
                    // “Subir Receta” (mock)
                    HStack {
                        Text("Subir Receta")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Image(systemName: "arrow.up.circle")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    LabeledField("Fecha")
                    
                    Button("Agregar") { }
                        .buttonStyle(.borderedProminent)
                }
                .cardStyle()
                
                // Card: Imagen + Fecha (mock)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Imagen").font(.subheadline)
                    HStack {
                        Image("receta")
                            .resizable()
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    
                    Text("Fecha").font(.subheadline)
                    HStack {
                        Text("30/08/2025")
                        Spacer()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .cardStyle()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
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
}
