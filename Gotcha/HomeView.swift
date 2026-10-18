//
//  HomeView.swift
//  Gotcha
//
//  Created on 9/9/26.
//

import SwiftUI

struct HomeView: View {
    @State private var showAlert = false
    @State private var lastWords = ""
    @State private var savedWords = ""
    @State private var profile: Profile?
    @State private var isLoading = true
    @State private var errorMessage: String?

    private let gameService = GameService()
    
    private func loadProfile() async {
        do {
            profile = try await gameService.getProfile()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    
    private func performTagOut() async {
        do {
            try await gameService.tagOut()
            profile = try await gameService.getProfile()
            lastWords = ""
            showAlert = false
        } catch {
            let nsError = error as NSError
            print("TAG OUT ERROR: \(error)")
            print("Error domain: \(nsError.domain)")
            print("Error code: \(nsError.code)")
            print("Error details: \(nsError.userInfo)")

            errorMessage = error.localizedDescription
        }
    }

    
    var body: some View {
        Spacer()
        VStack {
            Text("Your Profile")
                .font(.title)
                .fontWeight(.heavy)
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 80)
                    .foregroundStyle(Color.secondary)
                    .opacity(0.4)
                VStack {
                    Text("Tags")
                        .fontWeight(.semibold)
                    Text(String(profile?.tags ?? 0))
                }
            }
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 120)
                    .foregroundStyle(Color.secondary)
                    .opacity(0.4)
                VStack {
                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .textSelection(.enabled)
                    }
                    if (profile?.alive == true) {
                        Text("Your Target")
                            .fontWeight(.semibold)
                        Color.clear
                            .frame(height: 0.2)
                        Text(profile?.target.fullName ?? "Loading...")
                            .fontWeight(.bold)
                            .font(.title3)
                    }
                }
            }
            ZStack {
                if (!isLoading && profile != nil && !(profile?.alive ?? false) == false) {
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("Tag Out")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 15)) // Shapes the background
                            .opacity(0.8)
                    }
                    .frame(width: 300, height: 100)
                    .disabled(
                        isLoading || profile == nil || profile?.alive == false)
                }
                else if (profile?.alive == false) {
                    Text("Tagged Out")
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
            }
            .padding()
            .alert("Confirm Tag Out", isPresented: $showAlert) {
                TextField("Enter text here", text: $lastWords)
                
                Button("OK") {
                    Task {
                        await performTagOut()
                    }
                    savedWords = lastWords
                    lastWords = ""
                }
                
                Button("Cancel", role: .cancel) {
                    lastWords = ""
                }
            } message: {
                Text("Any last words?")
            }
        }
        .padding(20)
        .task {
            await loadProfile()
        }
        Spacer()
    }
    
}

#Preview {
    HomeView()
}
