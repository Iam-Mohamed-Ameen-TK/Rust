//
//  SEttingsView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 03/01/25.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @State private var isAboutUsExpanded: Bool = false
    @State private var isAppInfoExpanded: Bool = false
    @State private var isContactUsExpanded: Bool = false
    @State private var isFAQExpanded: Bool = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State private var showLogoutAlert: Bool = false
    @State private var isLoggedOut: Bool = false
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Settings")
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Spacer()
            }
            ScrollView {
                VStack(spacing: 16) {
                    SettingsToggle(title: "Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { newValue in
                            setAppearance(isDarkMode: newValue)
                        }
                    
                    SettingsExpandableSection(title: "About Us", isExpanded: $isAboutUsExpanded) {
                        Text("Welcome to RecipeMaster! We're passionate about helping you create delicious meals effortlessly. Explore thousands of recipes tailored to your taste and preferences, all offline and at your fingertips.")
                            .foregroundColor(.primary)
                            .font(.subheadline)
                    }
                    
                    SettingsExpandableSection(title: "App Information", isExpanded: $isAppInfoExpanded) {
                        Text("Version: 1.0.0\nLast Updated: December 2024")
                            .foregroundColor(.primary)
                            .font(.subheadline)
                    }
                    
                    SettingsExpandableSection(title: "Contact Us", isExpanded: $isContactUsExpanded) {
                        Text("Have questions or need help? Reach out to us:\nEmail: support@recipemaster.com\nPhone: +1 800 123 4567")
                            .foregroundColor(.primary)
                            .font(.subheadline)
                    }
                    
                    SettingsExpandableSection(title: "FAQ", isExpanded: $isFAQExpanded) {
                        Text("Have questions about the app? Here are some quick answers!")
                            .foregroundColor(.primary)
                            .font(.subheadline)
                    }
                    
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        Text("Logout")
                            .padding()
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                            .font(.system(size: 16, weight: .bold))
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text("Confirm Logout"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .destructive(Text("Logout")) {
                    logout()
                },
                secondaryButton: .cancel()
            )
        }
        .fullScreenCover(isPresented: $isLoggedOut) {
            LoginPage()
        }
    }

    private func setAppearance(isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
            }
        }
    }

    private func logout() {
        do {
            try Auth.auth().signOut()
            print("User logged out successfully.")
            isLoggedOut = true
        } catch {
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}

struct SettingsToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemBackground))
            
            HStack {
                HStack(spacing: 12) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .frame(alignment: .leading)
                    
                    Image(systemName: isOn ? "moon.fill" : "sun.max.fill")
                        .foregroundColor(isOn ? .yellow : .orange)
                        .font(.system(size: 16))
                }
                Spacer()
                Toggle("", isOn: $isOn)
                    .labelsHidden()
            }
            .padding()
        }
    }
}

struct SettingsExpandableSection<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
            }
            
            if isExpanded {
                content()
                    .padding(.horizontal)
                    .padding(.bottom)
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
    }
}

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Login View")
                .font(.system(size: 16, weight: .bold))
                .padding()
        }
    }
}

#Preview {
    SettingsView()
}
