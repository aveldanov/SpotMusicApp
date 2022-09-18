//
//  AuthManager.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import Foundation


final class AuthManager {

    static let shared = AuthManager()

    struct Constants {
        static let  clientID = "906d20caba24486eb1a6e9014f87a5ef"
        static let clientSecret = "fc2eb44d26aa4b4b8b1df0bf3e2e5e48"
    }

    private init() {}

    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let scope = "user-read-private"
        let redirect_uri = "https://www.google.com/"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(scope)&redirect_uri=\(redirect_uri)&show_dialog=TRUE"

        return URL(string: string)
    }

    var isSignedIn: Bool {
        return false
    }

    private var accessToken: String? {
        return nil
    }

    private var refreshToken: String? {
        return nil
    }

    private var tokenExpirationDate: Date? {
        return nil
    }

    private var shouldRefreshToken: Bool {
        return false
    }
}
