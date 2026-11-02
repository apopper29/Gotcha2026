
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
import Combine

@main
struct GotchaApp: App {
    @StateObject private var authManager = AuthManager()
    @StateObject private var locationManager = LocationManager()
    private let gameService = GameService()

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
            .environmentObject(locationManager)
            .onAppear {
                if authManager.user != nil {
                    locationManager.startTracking()
                }
            }
            .onChange(of: authManager.user?.uid) { oldUserID, newUserID in
                if newUserID != nil {
                    locationManager.startTracking()
                } else {
                    locationManager.stopTracking()
                }
            }
            .onReceive(locationManager.$location.compactMap { $0 }) { location in
                Task {
                    do {
                        try await gameService.updateLocation(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )

                        print("Location sent to Firebase successfully.")
                    } catch {
                        print("Failed to send location:", error.localizedDescription)
                    }
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}
