//
//  PasswordRecoveryView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//

import SwiftUI
import FirebaseAuth

struct PasswordRecovery: View {
    @State private var email = ""
    @State private var isLoading = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var navigateToOTP = false
    var body: some View {
        ZStack {
            Image("Login and SignUp")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                Text("Password Recovery")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Text("Enter your email to reset your password")
                    .foregroundColor(.white.opacity(0.8))

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

                Button(action: sendPasswordResetEmail) {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        HStack {
                            Text("Send Reset Email")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
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
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Notification"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage == "A password reset link has been sent to your email." {
                            navigateToOTP = true
                        }
                    }
                )
            }
            .navigationDestination(isPresented: $navigateToOTP) {
                LoginPage()
            }
        }
    }

    private func sendPasswordResetEmail() {
        guard !email.isEmpty else {
            alertMessage = "Please enter your email."
            showAlert = true
            return
        }

        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            isLoading = false
            if let error = error {
                alertMessage = error.localizedDescription
            } else {
                alertMessage = "A password reset link has been sent to your email."
            }
            showAlert = true
        }
    }
}

struct OTPVerificationView: View {
    let email: String

    var body: some View {
        VStack {
            Text("Verify OTP for \(email)")
                .font(.title)
                .padding()

        }
    }
}

#Preview {
    PasswordRecovery()
}
