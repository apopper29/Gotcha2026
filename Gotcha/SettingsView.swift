//
//  SettingsView.swift
//  Gotcha
//
//  Created on 10/17/26.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authManager: AuthManager
    var body: some View {
        Button("Sign Out", role: .destructive) {
            authManager.signOut()
        }
    }
}
