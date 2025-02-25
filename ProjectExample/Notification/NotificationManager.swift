//
//  NotificationManager.swift
//  Rust
//
//  Created by Mohamed Ameen on 19/02/25.
//


import SwiftUI

// MARK: - Notification Manager (Shared)
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    @Published var notifications: [Notification] = [] {
        didSet {
            saveNotifications()
        }
    }
    
    private let notificationsKey = "savedNotifications"
    
    init() {
        loadNotifications()
    }
    
    // Load notifications from UserDefaults
    private func loadNotifications() {
        if let data = UserDefaults.standard.data(forKey: notificationsKey) {
            if let decodedNotifications = try? JSONDecoder().decode([Notification].self, from: data) {
                notifications = decodedNotifications
            }
        }
    }
    
    // Save notifications to UserDefaults
    private func saveNotifications() {
        if let encodedNotifications = try? JSONEncoder().encode(notifications) {
            UserDefaults.standard.set(encodedNotifications, forKey: notificationsKey)
        }
    }
    
    // Fetch notifications from API or database
    func fetchNotifications() {
        // Simulate fetching notifications (do not overwrite existing notifications)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        }
    }
    
    func addNotification(title: String, content: String) {
        let newNotification = Notification(title: title, content: content, isRead: false)
        DispatchQueue.main.async {
            self.notifications.insert(newNotification, at: 0)
        }
    }
    
    func markAsRead(id: UUID) {
        if let index = notifications.firstIndex(where: { $0.id == id }) {
            notifications[index].isRead = true
        }
    }
    
    func clearAllNotifications() {
        notifications.removeAll()
    }
}
