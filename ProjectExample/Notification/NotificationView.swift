//
//  NotificationView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 03/01/25.
//

import SwiftUI

// MARK: - Notification Model
struct Notification: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    var isRead: Bool
}



// MARK: - Notification View
struct NotificationView: View {
    @ObservedObject var notificationManager = NotificationManager.shared
    @State private var selectedFilter: NotificationFilterOptions = .all
    @State private var isLoading = false
    
    private var filteredNotifications: [Notification] {
        switch selectedFilter {
        case .all:
            return notificationManager.notifications
        case .unread:
            return notificationManager.notifications.filter { !$0.isRead }
        case .read:
            return notificationManager.notifications.filter { $0.isRead }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                Text("Notifications")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Refresh Button
                Button(action: refreshNotifications) {
                    Image(systemName: "arrow.clockwise")
                        .rotationEffect(.degrees(isLoading ? 360 : 0))
                        .animation(isLoading ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isLoading)
                }
                
                // Clear All Button
                Button(action: notificationManager.clearAllNotifications) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 10)
            
            // Filter Buttons
            HStack {
                ForEach(NotificationFilterOptions.allCases, id: \.self) { filter in
                    Text(filter.rawValue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .fontWeight(selectedFilter == filter ? .bold : .regular)
                        .foregroundColor(selectedFilter == filter ? .white : .red)
                        .background(selectedFilter == filter ? Color.red : Color.clear)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedFilter = filter
                        }
                }
            }
            
            // Notification List
            ScrollView {
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else if filteredNotifications.isEmpty {
                    Text("No notifications to show.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    NotificationCellSectionView(title: "\(selectedFilter.rawValue) Notifications") {
                        ForEach(filteredNotifications) { notification in
                            NotificationCellView(notification: notification)
                                .onTapGesture {
                                    notificationManager.markAsRead(id: notification.id)
                                }
                        }
                    }
                }
            }
        }
        .padding(20)
        .onAppear {
            // Fetch notifications (but do not overwrite existing ones)
            notificationManager.fetchNotifications()
        }
    }
    
    // Refresh Function
    private func refreshNotifications() {
        isLoading = true
        notificationManager.fetchNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isLoading = false
        }
    }
}

// MARK: - Notification Cell Section
struct NotificationCellSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
            content
        }
    }
}

// MARK: - Notification Cell
struct NotificationCellView: View {
    var notification: Notification
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(notification.isRead ? Color.gray : Color.green)
                .frame(width: 10, height: 10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(notification.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}

// MARK: - Enum for Filters
enum NotificationFilterOptions: String, CaseIterable {
    case all = "All", unread = "Unread", read = "Read"
}

// MARK: - Preview
#Preview {
    NotificationView()
}

