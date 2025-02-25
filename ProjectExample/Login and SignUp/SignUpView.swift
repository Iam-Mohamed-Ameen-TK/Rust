//
//  SignUpView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//

import SwiftUI
import FirebaseAuth

struct SignUpPage: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var passwordVisible = false
    @State private var confirmPasswordVisible = false
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isLoading = false
    @State private var isSignedUp = false

    var body: some View {
        NavigationView {
            ZStack {
                Image("Login and SignUp")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Text("Sign Up Now!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Create new account")
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.gray)
                        TextField("Enter your full name", text: $fullName)
                            .autocapitalization(.words)
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.black)

                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.black)

                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if passwordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: {
                            passwordVisible.toggle()
                        }) {
                            Image(systemName: passwordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.black)

                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if confirmPasswordVisible {
                            TextField("Confirm Password", text: $confirmPassword)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                        }
                        Button(action: {
                            confirmPasswordVisible.toggle()
                        }) {
                            Image(systemName: confirmPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .foregroundColor(.black)

                    Button(action: {
                        signUpUser()
                    }) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign Up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                    .disabled(isLoading)
                    .padding(.top)

                    Spacer()
                }
                .padding(.horizontal, 40)
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }

                .navigationDestination(isPresented: $isSignedUp) {
                    LoginPage()
                }
            }
        }
    }

    private func signUpUser() {
        guard !fullName.trimmingCharacters(in: .whitespaces).isEmpty else {
            showError(message: "Full name is required.")
            return
        }

        guard fullName.count >= 6 else {
            showError(message: "Full name must be at least 6 characters.")
            return
        }

        guard let firstLetter = fullName.first, firstLetter.isUppercase else {
            showError(message: "Full name must start with a capital letter.")
            return
        }

        guard !email.isEmpty else {
            showError(message: "Email is required.")
            return
        }

        guard email.contains("@") && email.contains(".") else {
            showError(message: "Enter a valid email address.")
            return
        }

        guard !password.isEmpty else {
            showError(message: "Password is required.")
            return
        }

        guard password.count >= 6 else {
            showError(message: "Password must be at least 6 characters long.")
            return
        }

        guard password == confirmPassword else {
            showError(message: "Passwords do not match.")
            return
        }

        isLoading = true

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            isLoading = false

            if let error = error {
                print("Firebase Signup Error: \(error.localizedDescription)")
                showError(message: error.localizedDescription)
                return
            }

            if let user = result?.user {
                print("User signed up successfully: \(user.uid)")
                isSignedUp = true
            }
        }
    }
    
    /// Showing the error in sign UP
    /// - Parameter message: Firebase error
    private func showError(message: String) {
        errorMessage = message
        showError = true
    }
}

#Preview {
    SignUpPage()
}
