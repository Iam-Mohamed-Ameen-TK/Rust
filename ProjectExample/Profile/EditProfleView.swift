//
//  EditProfleView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 03/01/25.
//

import SwiftUI
import FirebaseAuth
import PhotosUI
import SwiftData

struct EditProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Query private var profiles: [Profile]
    
    @State private var name = ""
    @State private var bio = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImage: Image?
    @State private var imageData: Data?
    
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var passwordError: String?
    @State private var showChangePasswordFields = false
    
    @State private var showCurrentPassword = false
    @State private var showNewPassword = false
    @State private var showConfirmPassword = false
    
    @State private var showSuccessAlert = false
    @State private var alertMessage = ""
    
    private var currentProfile: Profile? {
        profiles.first
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .center, spacing: 15) {
                    if let profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.secondary.opacity(0.2), lineWidth: 2))
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.secondary)
                    }
                    
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Text("Choose Photo")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
                
                Group {
                    Text("Profile Information")
                        .font(.headline)
                        .padding(.bottom, 5)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Enter your name", text: $name)
                            .textFieldStyle(CustomTextFieldStyle())
                    }
                    .padding(.bottom, 15)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Bio")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .padding(10)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(10)
                            .onChange(of: bio) { oldValue, newValue in
                                if newValue.count > 150 {
                                    bio = String(newValue.prefix(150))
                                }
                            }

                        HStack {
                            Spacer()
                            Text("\(bio.count)/150")
                                .font(.caption)
                                .foregroundColor(bio.count == 150 ? .red : .gray)
                        }
                    }
                }
                
                Button(action: saveProfile) {
                    Text("Save Changes")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.vertical, 20)
                
                Divider()
                
                Group {
                    Button(action: {
                        withAnimation {
                            showChangePasswordFields.toggle()
                            if !showChangePasswordFields {
                                resetPasswordFields()
                            }
                        }
                    }) {
                        HStack {
                            Text("Change Password")
                                .font(.headline)
                            Spacer()
                            Image(systemName: showChangePasswordFields ? "chevron.up" : "chevron.down")
                        }
                        .foregroundColor(.primary)
                        .padding(.vertical, 10)
                    }
                    
                    if showChangePasswordFields {
                        VStack(alignment: .leading, spacing: 15) {
                            if let passwordError = passwordError {
                                Text(passwordError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .padding(.bottom, 5)
                            }
                            PasswordField(
                                title: "Current Password",
                                text: $currentPassword,
                                isVisible: $showCurrentPassword
                            )
                            PasswordField(
                                title: "New Password",
                                text: $newPassword,
                                isVisible: $showNewPassword
                            )
                            PasswordField(
                                title: "Confirm New Password",
                                text: $confirmPassword,
                                isVisible: $showConfirmPassword
                            )
                            
                            Button(action: changePassword) {
                                Text("Update Password")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.top, 10)
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Edit Profile")
        .background(Color(uiColor: .systemBackground))
        .onAppear(perform: loadCurrentProfile)
        .onChange(of: selectedImage) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        imageData = data
                        if let uiImage = UIImage(data: data) {
                            profileImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
        }
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") {
                showChangePasswordFields = false
                resetPasswordFields()
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadCurrentProfile() {
        if let profile = currentProfile {
            name = profile.name
            bio = profile.bio
            if let data = profile.imageData, let uiImage = UIImage(data: data) {
                profileImage = Image(uiImage: uiImage)
                imageData = data
            }
        }
    }
    
    private func resetPasswordFields() {
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
        passwordError = nil
        showCurrentPassword = false
        showNewPassword = false
        showConfirmPassword = false
    }
    
    private func saveProfile() {
        Task {
            if let selectedImage {
                if let data = try? await selectedImage.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        imageData = data
                        await MainActor.run {
                            profileImage = Image(uiImage: uiImage)
                        }
                    }
                }
            }
            
            await MainActor.run {
                if let profile = currentProfile {
                    profile.name = name
                    profile.bio = bio
                    if let imageData = imageData {
                        profile.imageData = imageData
                    }
                } else {
                    let profile = Profile(name: name, bio: bio, imageData: imageData)
                    modelContext.insert(profile)
                }
                
                do {
                    try modelContext.save()
                    alertMessage = "Saved changes successfully!"
                    showSuccessAlert = true
                } catch {
                    print("Error saving profile: \(error)")
                }
            }
        }
    }
    
    private func changePassword() {
        if newPassword != confirmPassword {
            passwordError = "New password and confirm password do not match."
            return
        }
        
        guard let user = Auth.auth().currentUser else {
            passwordError = "No user is currently logged in."
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: user.email ?? "", password: currentPassword)
        
        user.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                passwordError = "Current password is incorrect."
                return
            }
            
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    passwordError = "Failed to change password: \(error.localizedDescription)"
                } else {
                    alertMessage = "Password changed successfully!"
                    showSuccessAlert = true
                }
            }
        }
    }
}

struct PasswordField: View {
    let title: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                if isVisible {
                    TextField(title, text: $text)
                } else {
                    SecureField(title, text: $text)
                }
                
                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.secondary, lineWidth: 1)
            )
            .background(Color(uiColor: .secondarySystemBackground))
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
            .modelContainer(for: Profile.self)
    }
}

