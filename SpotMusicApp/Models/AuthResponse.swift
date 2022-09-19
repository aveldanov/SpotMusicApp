//
//  AuthResponse.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/17/22.
//

import Foundation

struct AuthResponse: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}
