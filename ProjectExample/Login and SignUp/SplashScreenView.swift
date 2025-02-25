//
//  ContentView.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//

import SwiftUI
import SwiftData

struct SplashScreen: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isLoading = false
    @State private var showLogin = false
    
    var body: some View {
        ZStack {
            Image("Login and SignUp")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Let's\nStart Cooking")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Powered by Recipe App")
                    .font(.system(size: 25))
                    .foregroundColor(.white)
                    .padding(.top, 8)
                
                Spacer()
                
                Text("Find best recipes for cooking")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 8)
                
                Button(action: {
                    startLoading()
                }) {
                    Text("Start Exploring")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover(isPresented: $showLogin) {
            LoginPage()
        }
    }
    
    private func startLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
            isLoading = false
            showLogin = true
        }
    }
}

#Preview {
    SplashScreen()
}
