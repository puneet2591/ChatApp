//
//  SignUpView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 27/08/25.
//

import SwiftUI

import SwiftUI

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isOnline: Bool = false
    
    @EnvironmentObject private var fbViewModel: FirebaseAuthViewModel
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 30)
                
                // Name Field
                TextField("Full Name", text: $name)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                
                // Email Field
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // Password Field with Toggle Visibility
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .foregroundColor(.white)
                    } else {
                        SecureField("Password", text: $password)
                            .foregroundColor(.white)
                    }
                    Button(action: { isPasswordVisible.toggle() }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                
                // Toggle for online and offline
                Toggle("Online", isOn: $isOnline)
                    .foregroundColor(.white)
                
                // Signup Button
                Button(action: {
                    // Handle signup action
                    fbViewModel.signUp(email: email, password: password, name: name, isOnline: isOnline)
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
            }
            .padding(30)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
