//
//  FirebaseAuthView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import SwiftUI

struct FirebaseAuthView: View {
    @EnvironmentObject private var viewModel: FirebaseAuthViewModel

    @State private var email = "cap@gmail.com"
    @State private var password = "Test@1234"

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                    
                    HStack {
                        
                        Button {
                            viewModel.signIn(email: email, password: password)
                        } label: {
                            Text("Sign In")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: SignupView()) {
                            Text("New user?")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .environmentObject(viewModel)
                .padding()
            }
        }
    }
}

struct FirebaseAuthView_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseAuthView()
    }
}
