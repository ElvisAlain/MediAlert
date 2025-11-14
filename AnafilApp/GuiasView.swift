//
//  GuiasView.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 21/09/25.
//

import SwiftUI
import SwiftData

struct GuiasView: View {
    @State private var showCMICAInfo = false
    
    // 1. Acceso a Idioma
    @Query(sort: \User.nombre) var users: [User]
    var currentUser: User? { users.first }
    var isEnglish: Bool { currentUser?.idiomaSeleccionado == "English" }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Label(isEnglish ? "Guide" : "Guía", systemImage: "book.fill")
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
                                Text(isEnglish ? "About Us (CMICA)" : "Conócenos (CMICA)")
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
                            Text(isEnglish ? "General Anaphylaxis Information" : "Información General de Anafilaxia")
                                .font(.title3.weight(.bold))
                            Spacer()
                        }
                        .padding(.bottom, 4)

                        // 1. Definición
                        Card {
                            TitleWithThumb(title: isEnglish ? "1. What is Anaphylaxis?" : "1. ¿Qué es la Anafilaxia?", imageName: "guias_anafilexia", thumbSize: 60)
                            bullets([
                                isEnglish ? "It is a severe allergic reaction of rapid onset and can be fatal." : "Es una reacción alérgica grave de presentación rápida y puede ser mortal.",
                                isEnglish ? "It is estimated that between 50 and 112 episodes occur per 100,000 people per year." : "Se estima que ocurren entre 50 y 112 episodios por cada 100,000 personas por año.",
                                isEnglish ? "Among these cases, mortality has been between 0.05% and 2%." : "Entre estos casos, la mortalidad se ha situado entre el 0,05 y el 2 %."
                            ])
                        }

                        // 2. Causas
                        Card {
                            TitleWithThumb(title: isEnglish ? "2. Most frequent causes" : "2. Causas más frecuentes", iconSystemName: "exclamationmark.triangle.fill")
                            bullets([
                                isEnglish ? "Food." : "Alimentos.",
                                isEnglish ? "Drugs (Medication)." : "Fármacos.",
                                isEnglish ? "Latex." : "Látex.",
                                isEnglish ? "Hymenoptera insect stings (bees, wasps)." : "Picaduras de insectos himenópteros (abejas, avispas)."
                            ])
                        }

                        // 3. Signos y Síntomas
                        Card {
                            TitleWithThumb(title: isEnglish ? "3. Signs and Symptoms" : "3. Signos y Síntomas", iconSystemName: "cross.case.fill")
                            
                            Group {
                                Text(isEnglish ? "Skin:" : "Piel:").bold() + Text(isEnglish ? " Red itchy hives, swelling and/or itching in palms of hands, soles of feet." : " Ronchas rojas que pican, hinchazón y/o picor en palmas de las manos, plantas de los pies.")
                                Divider().padding(.vertical, 4)
                                
                                Text(isEnglish ? "Respiratory:" : "Respiratorio:").bold() + Text(isEnglish ? " Cough, sensation of something stuck in the throat, wheezing and shortness of breath." : " Tos, sensación de algo atorado en la garganta, silbido y falta de aire.")
                                Divider().padding(.vertical, 4)
                                
                                Text(isEnglish ? "Cardiovascular:" : "Cardiovascular:").bold() + Text(isEnglish ? " Palpitations, dizziness, low blood pressure and fainting." : " Palpitaciones, mareo, baja de presión y desmayo.")
                                Divider().padding(.vertical, 4)
                                
                                Text(isEnglish ? "Digestive:" : "Digestivo:").bold() + Text(isEnglish ? " Nausea, vomiting, diarrhea." : " Náusea, vómito, diarrea.")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }

                        // 4. Qué hacer
                        Card {
                            TitleWithThumb(title: isEnglish ? "4. What to do if I suffer anaphylaxis?" : "4. ¿Qué hacer si sufro anafilaxia?", iconSystemName: "figure.run")
                            bullets([
                                isEnglish ? "In AnafilApp you will find graphic information on how to act." : "En AnafilApp encontrarás la información gráfica para saber cómo actuar.",
                                isEnglish ? "Notify school/work environment about your diagnosis so they know how to help." : "Se debe avisar en el ámbito laboral y/o escolar acerca de su diagnóstico para que sepan cómo actuar.",
                                isEnglish ? "The affected person must go to an EMERGENCY service immediately." : "La persona afectada debe acudir a un servicio de URGENCIAS inmediatamente.",
                                isEnglish ? "If possible, request a BASAL SERUM TRYPTASE test to confirm diagnosis." : "Si es posible, solicitar prueba de TRIPTASA SÉRICA BASAL para confirmar diagnóstico."
                            ])
                        }

                        // 5. Retirada del Alérgeno
                        Card {
                            TitleWithThumb(title: isEnglish ? "5. Allergen Withdrawal" : "5. Retirada del Alérgeno", imageName: "guias_retiradoAbeja", thumbSize: 60)
                            bullets([
                                isEnglish ? "Suspend suspected drugs." : "Suspender fármacos sospechosos.",
                                isEnglish ? "Remove bee sting quickly (speed prevails over form)." : "Retirar aguijón de abeja rápidamente (prima la rapidez sobre la forma).",
                                isEnglish ? "Do not induce vomiting for food, but remove food debris from mouth." : "No provocar vómito en alimentos, pero sí retirar restos de la boca.",
                                isEnglish ? "Remove latex products (gloves, probes) if allergy is suspected." : "Retirar productos de látex (guantes, sondas) si hay sospecha de alergia."
                            ])
                        }

                        // 6. Adrenalina (Intramuscular)
                        Card {
                            TitleWithThumb(title: isEnglish ? "6. Apply Adrenaline" : "6. Aplicar Adrenalina", imageName: "guias_aplicacion", thumbSize: 60)
                            bullets([
                                isEnglish ? "Intramuscular adrenaline is the ONLY treatment of choice." : "La adrenalina intramuscular es el ÚNICO tratamiento de elección.",
                                isEnglish ? "It must be administered QUICKLY." : "Se debe administrar RÁPIDAMENTE.",
                                isEnglish ? "Every person at risk should carry adrenaline." : "Toda persona con riesgo debería llevar consigo adrenalina.",
                                isEnglish ? "Apply following medical instructions for intramuscular injection." : "Aplicar siguiendo las instrucciones médicas para inyección intramuscular."
                            ])
                        }
                        
                        // 7. Prevención
                        Card {
                            TitleWithThumb(title: isEnglish ? "7. Can it be prevented?" : "7. ¿Se puede prevenir?", iconSystemName: "shield.fill")
                            Text(isEnglish ? "There is no diet or preventive study for the first event. To prevent recurrence:" : "No existe dieta o estudio preventivo para el primer evento. Para prevenir que suceda nuevamente:")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .padding(.bottom, 4)
                            
                            bullets([
                                isEnglish ? "Attend assessment by Allergology." : "Acudir a valoración por Alergología.",
                                isEnglish ? "Perform relevant allergological studies indicated by the specialist." : "Hacer los estudios alergológicos pertinentes indicados por el especialista.",
                                isEnglish ? "Have IM Adrenaline and instructions for use in a new event." : "Contar con Adrenalina IM e instrucciones para usarla en nuevo evento.",
                                isEnglish ? "Notify family, school and work environment." : "Avisar a familiares, ámbito escolar y laboral.",
                                isEnglish ? "Strictly avoid the responsible allergen." : "Evitar el alérgeno responsable."
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
                CMICAInfoView(isEnglish: isEnglish)
                    .presentationDetents([.fraction(0.50)])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

// Vista del Popup de CMICA
struct CMICAInfoView: View {
    var isEnglish: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("cmica_logo")
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .padding(.top, 20)
            
            Text("CMICA")
                .font(.title.bold())
            
            Text(isEnglish ? "Mexican College of Clinical Immunology and Allergy A.C." : "Colegio Mexicano de Inmunología Clínica y Alergia A.C.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Text("•")
                        Text(isEnglish ? "Founded in 1946, it is the body that groups all Medical Specialists in Allergy and Immunology in the country." : "Fue fundado en 1946 y es el organismo que agrupa a todos los Médicos Especialistas en Alergia e Inmunología del país.")
                    }
                    HStack(alignment: .top) {
                        Text("•")
                        Text(isEnglish ? "Its main function is to promote academic growth and continuing medical education for its members through the organization of update courses, national and international congresses, symposiums, and workshops." : "Su principal función es promover el crecimiento académico y la educación médica continua de sus miembros mediante la organización de cursos de actualización, congresos nacionales e internacionales, simposios y talleres.")
                    }
                }
                .font(.body)
                .padding()
            }
        }
        .padding(.bottom, 20)
    }
}

// Componentes Reutilizables

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

#Preview {
    GuiasView()
}
