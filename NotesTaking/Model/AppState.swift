//
//  AppState.swift
//  NotesTaking
//
//  Created by Taliya Meyswara on 26/05/24.
//

import Foundation

// for routing
enum Route: Hashable{
    case main
    case login
    case register
    case profile
}

class AppState: ObservableObject{
    // put something in this array it means this is where you want to go
    @Published var routes: [Route] = []
}
