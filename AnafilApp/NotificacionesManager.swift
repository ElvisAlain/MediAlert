//
//  NotificacionesManager.swift
//  AnafilApp
//
//  Created by Elvis Alain Calzada Trinidad on 21/11/25.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permiso de notificaciones concedido")
            } else if let error = error {
                print("Error pidiendo permisos: \(error.localizedDescription)")
            }
        }
    }
    
    // Función para mostrar notificación con App en Primer Plano
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .list])
    }
    
    func scheduleAdrenalineNotifications(for adrenalina: Adrenalina, isEnglish: Bool) {
        let idBase = String(Int(adrenalina.fechaRegistro.timeIntervalSince1970))
        
        // Alerta 1 mes antes
        if let oneMonthBefore = Calendar.current.date(byAdding: .month, value: -1, to: adrenalina.fechaCaducidad), oneMonthBefore > Date() {
            scheduleNotification(
                id: idBase + "_1month",
                date: oneMonthBefore,
                title: isEnglish ? "Adrenaline Expiration Warning" : "Aviso de Caducidad Adrenalina",
                body: isEnglish ? "Your adrenaline expires in 1 month. Please plan a replacement." : "Tu adrenalina caduca en 1 mes. Planea su reposición."
            )
        }
        
        // Alerta 1 semana antes
        if let oneWeekBefore = Calendar.current.date(byAdding: .day, value: -7, to: adrenalina.fechaCaducidad), oneWeekBefore > Date() {
            scheduleNotification(
                id: idBase + "_1week",
                date: oneWeekBefore,
                title: isEnglish ? "Urgent: Adrenaline Expiring" : "Urgente: Adrenalina por Caducar",
                body: isEnglish ? "Your adrenaline expires in 7 days." : "Tu adrenalina caduca en 7 días."
            )
        }
        
        // El día de la caducidad
        if adrenalina.fechaCaducidad > Date() {
            scheduleNotification(
                id: idBase + "_expired",
                date: adrenalina.fechaCaducidad,
                title: isEnglish ? "Adrenaline EXPIRED" : "Adrenalina CADUCADA",
                body: isEnglish ? "Your adrenaline has expired today. Replace it immediately." : "Tu adrenalina ha caducado hoy. Reemplázala inmediatamente."
            )
        }
    }
    
    func cancelNotifications(for adrenalina: Adrenalina) {
        let idBase = String(Int(adrenalina.fechaRegistro.timeIntervalSince1970))
        let ids = [idBase + "_1month", idBase + "_1week", idBase + "_expired"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    private func scheduleNotification(id: String, date: Date, title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error agendando notificación: \(error)")
            }
        }
    }
}
