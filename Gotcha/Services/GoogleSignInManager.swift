//
//  GoogleSignInManager.swift
//  Gotcha
//
//  Created on 10/17/26.
//


import Foundation
import UIKit
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@MainActor
final class GoogleSignInManager: ObservableObject {
    @Published var isSigningIn = false
    @Published var errorMessage: String?

    func signIn(presenting viewController: UIViewController) {
        guard !isSigningIn else { return }

        guard let clientID = FirebaseApp.app()?.options.clientID else {
            errorMessage = "Firebase client ID is missing."
            return
        }

        isSigningIn = true
        errorMessage = nil

        GIDSignIn.sharedInstance.configuration =
            GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(
            withPresenting: viewController
        ) { [weak self] result, error in
            Task { @MainActor in
                guard let self else { return }

                if let error {
                    self.errorMessage = error.localizedDescription
                    self.isSigningIn = false
                    return
                }

                guard let googleUser = result?.user,
                      let idToken = googleUser.idToken?.tokenString else {
                    self.errorMessage = "Unable to retrieve Google credentials."
                    self.isSigningIn = false
                    return
                }

                let credential = GoogleAuthProvider.credential(
                    withIDToken: idToken,
                    accessToken: googleUser.accessToken.tokenString
                )

                do {
                    try await Auth.auth().signIn(with: credential)
                    // AuthManager observes this change automatically.
                } catch {
                    self.errorMessage = error.localizedDescription
                }

                self.isSigningIn = false
            }
        }
    }
}
