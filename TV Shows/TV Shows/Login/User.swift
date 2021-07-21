//
//  User.swift
//  TV Shows
//
//  Created by Infinum on 20.07.2021..
//

import Foundation

struct User: Decodable {
    let id: String
    let email: String
    let imageUrl: String?
    

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case imageUrl = "image_url"
    }
}

struct UserResponse: Decodable {
    let user: User
}

struct AuthInfo: Codable {

    let accessToken: String
    let client: String
    let tokenType: String
    let expiry: String
    let uid: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access-token"
        case client = "client"
        case tokenType = "token-type"
        case expiry = "expiry"
        case uid = "uid"
    }

    init(headers: [String: String]) throws {
        let data = try JSONSerialization.data(withJSONObject: headers, options: .prettyPrinted)
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: data)
    }

    var headers: [String: String] {
        do {
            let data = try JSONEncoder().encode(self)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
            return jsonObject as? [String: String] ?? [:]
        } catch {
            return [:]
        }
    }

}
