//
//  GuiasView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 21/09/25.
//

import SwiftUI

struct GuiasView: View {
    @State private var showCMICAInfo = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Label("Guía", systemImage: "book.fill")
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

                // Contenido Principal
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // Botón Conócenos (CMICA)
                        Button(action: { showCMICAInfo = true }) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                Text("Conócenos (CMICA)")
                                    .fontWeight(.semibold)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                        }
                        .padding(.top, 4)
                        
                        // Título Principal
                        HStack {
                            Image(systemName: "text.book.closed")
                                .foregroundStyle(.orange)
                            Text("Información General de Anafilaxia")
                                .font(.title3.weight(.bold))
                            Spacer()
                        }
                        .padding(.bottom, 4)

                        // 1. Definición
                        Card {
                            TitleWithThumb(title: "1. ¿Qué es la Anafilaxia?", imageName: "guias_anafilexia", thumbSize: 60)
                            bullets([
                                "Es una reacción alérgica grave de presentación rápida y puede ser mortal.",
                                "Se estima que ocurren entre 50 y 112 episodios por cada 100,000 personas por año.",
                                "Entre estos casos, la mortalidad se ha situado entre el 0,05 y el 2 %."
                            ])
                        }

                        // 2. Causas
                        Card {
                            TitleWithThumb(title: "2. Causas más frecuentes", iconSystemName: "exclamationmark.triangle.fill")
                            bullets([
                                "Alimentos.",
                                "Fármacos.",
                                "Látex.",
                                "Picaduras de insectos himenópteros (abejas, avispas)."
                            ])
                        }

                        // 3. Signos y Síntomas
                        Card {
                            TitleWithThumb(title: "3. Signos y Síntomas", iconSystemName: "cross.case.fill")
                            
                            Group {
                                Text("Piel:").bold() + Text(" Ronchas rojas que pican, hinchazón y/o picor en palmas de las manos, plantas de los pies.")
                                Divider().padding(.vertical, 4)
                                
                                Text("Respiratorio:").bold() + Text(" Tos, sensación de algo atorado en la garganta, silbido y falta de aire.")
                                Divider().padding(.vertical, 4)
                                
                                Text("Cardiovascular:").bold() + Text(" Palpitaciones, mareo, baja de presión y desmayo.")
                                Divider().padding(.vertical, 4)
                                
                                Text("Digestivo:").bold() + Text(" Náusea, vómito, diarrea.")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }

                        // 4. Qué hacer
                        Card {
                            TitleWithThumb(title: "4. ¿Qué hacer si sufro anafilaxia?", iconSystemName: "figure.run")
                            bullets([
                                "En AnafilApp encontrarás la información gráfica para saber cómo actuar.",
                                "Se debe avisar en el ámbito laboral y/o escolar acerca de su diagnóstico para que sepan cómo actuar.",
                                "La persona afectada debe acudir a un servicio de URGENCIAS inmediatamente.",
                                "Si es posible, solicitar prueba de TRIPTASA SÉRICA BASAL para confirmar diagnóstico."
                            ])
                        }

                        // 5. Retirada del Alérgeno
                        Card {
                            TitleWithThumb(title: "5. Retirada del Alérgeno", imageName: "guias_retiradoAbeja", thumbSize: 60)
                            bullets([
                                "Suspender fármacos sospechosos.",
                                "Retirar aguijón de abeja rápidamente (prima la rapidez sobre la forma).",
                                "No provocar vómito en alimentos, pero sí retirar restos de la boca.",
                                "Retirar productos de látex (guantes, sondas) si hay sospecha de alergia."
                            ])
                        }

                        // 6. Adrenalina (Intramuscular)
                        Card {
                            TitleWithThumb(title: "6. Aplicar Adrenalina", imageName: "guias_aplicacion", thumbSize: 60)
                            bullets([
                                "La adrenalina intramuscular es el ÚNICO tratamiento de elección.",
                                "Se debe administrar RÁPIDAMENTE.",
                                "Toda persona con riesgo debería llevar consigo adrenalina.",
                                "Aplicar siguiendo las instrucciones médicas para inyección intramuscular."
                            ])
                        }
                        
                        // 7. Prevención
                        Card {
                            TitleWithThumb(title: "7. ¿Se puede prevenir?", iconSystemName: "shield.fill")
                            Text("No existe dieta o estudio preventivo para el primer evento. Para prevenir que suceda nuevamente:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 4)
                            
                            bullets([
                                "Acudir a valoración por Alergología.",
                                "Hacer los estudios alergológicos pertinentes indicados por el especialista.",
                                "Contar con Adrenalina IM e instrucciones para usarla en nuevo evento.",
                                "Avisar a familiares, ámbito escolar y laboral.",
                                "Evitar el alérgeno responsable."
                            ])
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                
                // Menú Inferior
                Spacer(minLength: 0)
                MenuInferior(activeTab: "guias")
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            // Popup de CMICA
            .sheet(isPresented: $showCMICAInfo) {
                CMICAInfoView()
                    .presentationDetents([.fraction(0.50)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// Vista del Popup de CMICA
struct CMICAInfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("cmica_logo")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .padding(.top, 20)
          
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Fue fundado en 1946 y es el organismo que agrupa a todos los Médicos Especialistas en Alergia e Inmunología del país.")
                    }
                    HStack(alignment: .top) {
                        Text("•")
                        Text("Su principal función es promover el crecimiento académico y la educación médica continua de sus miembros mediante la organización de cursos de actualización, congresos nacionales e internacionales, simposios y talleres.")
                    }
                }
                .font(.body)
                .padding()
            }
        }
        .padding(.bottom, 20)
    }
}

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
    let iconSystemName: String?
    var thumbSize: CGFloat

    init(title: String, imageName: String? = nil, iconSystemName: String? = nil, thumbSize: CGFloat = 60) {
        self.title = title
        self.imageName = imageName
        self.iconSystemName = iconSystemName
        self.thumbSize = thumbSize
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
            
            Spacer()
            
            Group {
                if let name = imageName, UIImage(named: name) != nil {
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(width: thumbSize, height: thumbSize)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else if let iconName = iconSystemName {
                    Image(systemName: iconName)
                        .font(.system(size: 30))
                        .foregroundColor(.blue.opacity(0.6))
                        .frame(width: thumbSize, height: thumbSize)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
}

@ViewBuilder
private func bullets(_ items: [String]) -> some View {
    VStack(alignment: .leading, spacing: 6) {
        ForEach(items, id: \.self) { item in
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "circle.fill")
                    .font(.system(size: 6))
                    .foregroundStyle(.gray)
                    .padding(.top, 7)
                Text(item)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
