//
//  LoginView.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 26/05/24.
//

import SwiftUI

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject private var appState: AppState
    
    
    private var isFormValid: Bool{
        !email.isEmptyOrWhiteSpace && !password.isEmptyOrWhiteSpace
    }
    
    private func login() async {
        do{
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            // go to the main screen
            appState.routes.append(.main)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            Text("NoteTaking App📝")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text("Login to your account")
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 12) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
               
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Spacer()
                    
                    Button(action: {
                        Task {
                            await login()
                        }
                    }) {
                        Text("Log In")
                            .fontWeight(.bold)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        appState.routes.append(.register)
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 300)
            Spacer()
        }
    }
}


#Preview {
    LoginView()
        .environmentObject(AppState())
}
