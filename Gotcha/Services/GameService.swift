//
//  GameService.swift
//  Gotcha
//
//  Created on 10/5/26.
//

import FirebaseFunctions
import Foundation

final class GameService {
    private let functions = Functions.functions()
    
    
    func getProfile() async throws -> Profile {
        let result = try await functions
            .httpsCallable("getProfile")
            .call([:] as [String: Any])

        guard let data = result.data as? [String: Any] else {
            print("getProfile returned unexpected data:", result.data)
            throw GameError.invalidResponse
        }

        // Existing profiles return { "profile": {...} }.
        // New profiles return the profile object directly.
        let profileData: Any
        if let wrappedProfile = data["profile"] {
            profileData = wrappedProfile
        } else {
            profileData = data
        }

        guard JSONSerialization.isValidJSONObject(profileData) else {
            print("Invalid profile JSON:", profileData)
            throw GameError.invalidResponse
        }

        let jsonData = try JSONSerialization.data(withJSONObject: profileData)

        do {
            return try JSONDecoder().decode(Profile.self, from: jsonData)
        } catch {
            print("Could not decode Profile:", error)
            print("Profile response:", String(data: jsonData, encoding: .utf8) ?? "<unreadable>")
            throw error
        }
    }
    
    func tagOut() async throws {
        _ = try await functions
            .httpsCallable("tagOut")
            .call([:] as [String: Any])
    }

}

enum GameError: LocalizedError {
    case invalidResponse
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server returned an invalid response."
        }
    }
}
