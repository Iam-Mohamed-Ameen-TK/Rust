//
//  LoginView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//

import SwiftUI
import FirebaseAuth

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoggedIn = false
    @State private var passwordVisible = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("Login and SignUp")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer()

                    Text("Welcome Back!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text("Please enter your account here")
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
                        Spacer()
                        NavigationLink(destination: PasswordRecovery()) {
                            Text("Forgot password?")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }

                    Button(action: login) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .padding(.top)

                    Spacer()
                    
                    HStack {
                        Text("Don't have any account?")
                            .foregroundColor(.white.opacity(0.8))

                        NavigationLink(destination: SignUpPage()) {
                            Text("Sign Up")
                                .foregroundColor(.red)
                        }
                    }
                }
                .padding(.horizontal, 40)

                NavigationLink(
                    destination: TabbarView(),
                    isActive: $isLoggedIn,
                    label: { EmptyView() }
                )
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                isLoggedIn = true
            }
        }
    }
}

#Preview {
    LoginPage()
}
