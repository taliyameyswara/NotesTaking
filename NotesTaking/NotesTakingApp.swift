//
//  NotesTakingApp.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 26/05/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

@main
struct NotesTakingApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        FirebaseApp.configure()
    }
    
    @StateObject private var appState = AppState()
    @StateObject private var model = DataSource()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.routes){
                ZStack{
          
                    if Auth.auth().currentUser != nil {
                        ContentView()
                    } else{
                        LoginView()
                    }
                }.navigationDestination(for: Route.self) {
                    route in
                    switch route{
                    case .main:
                        ContentView()
                    case .login:
                        LoginView()
                    case .register:
                        RegisterView()
                    case .profile:
                        ProfileView()
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
            }
            .environmentObject(appState)
            .environmentObject(model)
        }
    }
}


