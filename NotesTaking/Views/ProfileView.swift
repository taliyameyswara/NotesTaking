//
// ProfileView.swift
// NotesTaking
//
// Created by Taliya Meyswara on 26/05/24.
//


import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @State private var userData: UserData?
    @State private var errorMessage = ""
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var dataSource: DataSource
    
    private func fetchData() {
        guard let user = Auth.auth().currentUser else {
            self.errorMessage = "No user is logged in"
            return
        }
        dataSource.fetchUserData(userId: user.uid) { result in
            switch result {
            case .success(let userData):
                self.userData = userData
            case .failure(let error):
                self.errorMessage = "Error fetching user data: \(error.localizedDescription)"
            }
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            appState.routes.append(.login)
        } catch {
            self.errorMessage = "Failed to logout: \(error.localizedDescription)"
        }
    }
    
    var body: some View {
        VStack {
            if let userData = userData {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                        
                        VStack(alignment: .leading) {
                            Text("Full Name:")
                                .font(.headline)
                            Text(userData.fullName)
                                .font(.title)
                        }
                        .padding()
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text("Email")
                                .font(.headline)
                        }
                        Text(userData.email)
                            .font(.body)
                        
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("Phone Number")
                                .font(.headline)
                        }
                        Text(userData.phoneNumber)
                            .font(.body)
                    }
                    .padding()
                    Spacer()
                }
            
            } else {
                ProgressView("Loading...")
            }
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            HStack{
                Button(action: {
                    logout()
                }) {
                    Text("Logout")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .padding(.horizontal)
                Spacer()
               
            }
      
        }
        Spacer()
        .onAppear {
            fetchData()
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
        .environmentObject(DataSource())
}
