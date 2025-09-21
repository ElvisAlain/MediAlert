//
//  GuiasView.swift
//  MediAlert
//
//  Created by Elvis Alain Calzada Trinidad on 21/09/25.
//

import SwiftUI

struct GuiasView: View {
    @State private var page = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Label("Guía", systemImage: "book.fill")
                        .font(.title3.weight(.semibold))
                    Spacer()
                    HStack(spacing: 14) {
                        NavigationLink{BotiquinView()} label: {Image(systemName:"cross.case")}
                        // Image(systemName: "cross.case")
                        Image(systemName: "globe")
                    }
                    .font(.title3)
                }
                .padding(.horizontal)
                .padding(.top, 12)

                // Swipe
                TabView(selection: $page) {
                    GuiaSintomasPage().tag(0)
                    GuiaQueHacerPage().tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))

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
                    Image(systemName: "book.fill")
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

// Síntomas

private struct GuiaSintomasPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Título
                HStack {
                    Image(systemName: "text.book.closed")
                    Text("Síntomas en la Anafilaxia")
                        .font(.title3.weight(.semibold))
                    Spacer()
                }

                // Secciones
                Card {
                    TitleWithThumb(title: "1. Piel", imageName: "guias_piel")
                    bullets([
                        "Ronchas rojas que pican.",
                        "Hinchazón y/o picor en palmas de las manos.",
                        "Hinchazón y/o picor en plantas de los pies."
                    ])
                }

                Card {
                    TitleWithThumb(title: "2. Respiratorio", imageName: "guias_respiratorio")
                    bullets([
                        "Tos.",
                        "Sensación de algo atorado en la garganta.",
                        "Silbidos en el pecho.",
                        "Falta de aire."
                    ])
                }

                Card {
                    TitleWithThumb(title: "3. Cardiovascular", imageName: "guias_cardiovascular")
                    bullets([
                        "Palpitaciones.",
                        "Mareo.",
                        "Baja presión.",
                        "Desmayo."
                    ])
                }

                Card {
                    TitleWithThumb(title: "4. Digestivo", imageName: "guias_digestivo")
                    bullets([
                        "Náuseas.",
                        "Vómito.",
                        "Diarrea.",
                        "Sabor metálico en la boca."
                    ])
                }

                Card {
                    Text("Qué hacer si detectas valores anormales")
                        .font(.headline)
                    bullet("Mantén la calma.", icon: "checkmark.seal.fill", color: .green)
                    bullet("Repite la medición para confirmar.", icon: "checkmark.seal.fill", color: .green)
                    bullet("Si hay riesgo, llama al 911 o usa el botón SOS.", icon: "exclamationmark.triangle.fill", color: .yellow)
                    bullet("No suspendas tratamientos sin indicación médica.", icon: "info.circle.fill", color: .blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// ¿Qué hacer? (Guía 2)

private struct GuiaQueHacerPage: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Título
                HStack {
                    Image(systemName: "text.book.closed")
                    Text("¿Qué hacer cuando se presenta una anafilaxia?")
                        .font(.title3.weight(.semibold))
                    Spacer()
                }

                Card {
                    TitleWithThumb(title: "1. Reconocer la anafilaxia", imageName: "guias_anafilexia", thumbSize: 80)
                    bullets([
                        "Reacción alérgica grave de presentación rápida y potencialmente mortal.",
                        "Entre 50–112 episodios por cada 100,000 personas/año.",
                        "Mortalidad estimada entre 0.05% y 2%.",
                        "(Consulta la guía de síntomas para reconocerla)."
                    ])
                }

                Card {
                    TitleWithThumb(title: "2. Retirado del alérgeno", imageName: "guias_retirado", thumbSize: 80)
                    bullets([
                        "Suspender fármacos sospechosos.",
                        "Retirar aguijón tras picadura de abeja (prima la rapidez).",
                        "No provocar vómito; retirar restos de alimento en la boca.",
                        "Retirar productos de látex si se sospecha alergia."
                    ])
                }

                Card {
                    TitleWithThumb(title: "3. Aplicar la Adrenalina RÁPIDAMENTE", imageName: "guias_aplicacion", thumbSize: 80)
                    bullets([
                        "Preparar el autoinyector/jeringa con la dosis correcta.",
                        "Sitio: cara anterolateral del muslo, a medio camino entre cadera y rodilla.",
                        "Inyección intramuscular con ángulo de 90°.",
                        "Retirar aguja y masajear suavemente la zona."
                    ])
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// Reutilizables

// Tarjeta
@ViewBuilder
private func Card<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 8) {
        content()
    }
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(12)
    .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
}

private struct TitleWithThumb: View {
    let title: String
    let imageName: String?
    var thumbSize: CGFloat = 60

    init(title: String, imageName: String? = nil, thumbSize: CGFloat = 60) {
        self.title = title
        self.imageName = imageName
        self.thumbSize = thumbSize
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title).font(.headline).fontWeight(.semibold)
            Spacer()
            Group {
                if let name = imageName, UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: thumbSize, height: thumbSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray5))
                        .frame(width: thumbSize, height: thumbSize)
                        .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                }
            }
        }
    }
}

// Viñetas
@ViewBuilder
private func bullets(_ items: [String]) -> some View {
    VStack(alignment: .leading, spacing: 6) {
        ForEach(items, id: \.self) { bullet($0) }
    }
}
@ViewBuilder
private func bullet(_ text: String, icon: String = "circle.fill", color: Color = .secondary) -> some View {
    HStack(alignment: .top, spacing: 8) {
        Image(systemName: icon).font(.system(size: 8)).foregroundStyle(color).padding(.top, 6)
        Text(text)
    }
}

#Preview {
    GuiasView()
}
