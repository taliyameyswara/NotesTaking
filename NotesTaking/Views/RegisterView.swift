//
//  Register View.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 22/05/24.
//

import SwiftUI
import FirebaseAuth

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var errorMessage = ""
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var dataSource: DataSource
    
    private func register() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = result.user
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = fullName
            try await changeRequest.commitChanges()
            
            // save data user in firestore
            dataSource.createUser(email: email, fullName: fullName, phoneNumber: phoneNumber) { success in
                if success {
                    appState.routes.append(.login)
                } else {
                    self.errorMessage = "Error saving user data"
                }
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        VStack {
            
            Spacer()
            Text("NoteTaking App📝")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            Text("Create new account")
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 12) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Full Name", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack{
                    Button(action: {
                        Task {
                            await register()
                        }
                    }) {
                        Text("Register")
                            .frame(maxWidth: .infinity)
                    }
                }
                
                HStack{
                    Text("Have an account?")
                        .foregroundColor(.gray)
                    Button("Login") {
                        appState.routes.append(.login)
                    }   
                    .buttonStyle(PlainButtonStyle())
                    .fontWeight(.bold)
                }
                .padding(.top, 2)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 300)
            Spacer()
            
        }
        .padding()
    }
}

#Preview {
    RegisterView()
        .environmentObject(AppState())
        .environmentObject(DataSource())
}
