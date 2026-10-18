//
//  Profile.swift
//  Gotcha
//
//  Created on 10/5/26.
//


import Foundation

struct Profile: Codable {
    let alive: Bool
    let role: String
    let chaser: String
    let className: String
    let dayOrBoard: String
    let firstName: String
    let lastName: String
    let tags: Int
    let target: Target
}

struct Target: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let location: String?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    static let none = Target(
        firstName: "None",
        lastName: "",
        email: "",
        location: nil
    )
}

extension Profile {
    enum CodingKeys: String, CodingKey {
        case alive
        case role
        case chaser
        case className = "class"
        case dayOrBoard = "dayorboard"
        case firstName
        case lastName
        case tags
        case target
    }
}
