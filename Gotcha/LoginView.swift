//
//  LoginView.swift
//  Gotcha
//
//  Created on 10/17/26.
//

import SwiftUI
import UIKit
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @StateObject private var googleSignIn = GoogleSignInManager()

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "person.2.circle.fill")
                .font(.system(size: 76))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.tint)

            VStack(spacing: 10) {
                Text("Welcome to Gotcha")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text("Sign in to continue")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if googleSignIn.isSigningIn {
                ProgressView("Signing in...")
                    .frame(height: 50)
            } else {
                GoogleSignInButton(
                    scheme: .light,
                    style: .wide,
                    state: .normal
                ) {
                    startGoogleSignIn()
                }
                .frame(height: 50)
            }

            if let error = googleSignIn.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            }

            Spacer()

            Text("Secure sign-in powered by Google")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func startGoogleSignIn() {
        guard let controller = UIApplication.shared
            .gotchaRootViewController else {
            googleSignIn.errorMessage =
                "Unable to open Google Sign-In. Please try again."
            return
        }

        googleSignIn.signIn(presenting: controller)
    }
}

private extension UIApplication {
    var gotchaRootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
