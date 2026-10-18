//
//  AuthManager.swift
//  Gotcha
//
//  Created on 10/17/26.
//

import Foundation
import FirebaseAuth
import Combine

@MainActor
final class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var isLoading = true
    @Published var errorMessage: String?

    private var listener: AuthStateDidChangeListenerHandle?

    init() {
        listener = Auth.auth().addStateDidChangeListener {
            [weak self] _, user in

            Task { @MainActor in
                self?.user = user
                self?.isLoading = false
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            errorMessage = nil
        } catch {
            errorMessage = "Unable to sign out. Please try again."
        }
    }

    deinit {
        if let listener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
    }
}
