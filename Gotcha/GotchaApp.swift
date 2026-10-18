
//
//  GotchaApp.swift
//  Gotcha
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFunctions
import FirebaseFirestore
import GoogleSignIn

@main
struct GotchaApp: App {
    @StateObject private var authManager = AuthManager()

    init() {
        FirebaseApp.configure()

#if DEBUG
        // Connect Firebase Authentication to the local emulator
        Auth.auth().useEmulator(
            withHost: "127.0.0.1",
            port: 9099
        )
        
        Functions.functions().useEmulator(
            withHost: "127.0.0.1",
            port: 5001
        )

        // Connect Cloud Firestore to the local emulator
        let db = Firestore.firestore()
        let settings = db.settings
        settings.host = "127.0.0.1:8080"
        settings.isSSLEnabled = false
        db.settings = settings
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if authManager.isLoading {
                    ProgressView("Loading Gotcha...")
                } else if authManager.user != nil {
                    ContentView()
                } else {
                    LoginView()
                }
            }
            .environmentObject(authManager)
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }

}
