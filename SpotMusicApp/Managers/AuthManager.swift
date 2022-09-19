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
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
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
        return accessToken != nil
    }

    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }

    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }

    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }

    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300 //5 mins


        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate // refresh 5 mins before expiration date
    }


    public func exchangeCodeForToken(code: String, completion: @escaping (Bool)->Void) {
        // get token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"),
                                 URLQueryItem(name: "code", value: code),
                                 URLQueryItem(name: "redirect_uri", value: "https://www.google.com/")]


        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.httpBody = components.query?.data(using: .utf8)


        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)

        guard let base64String = data?.base64EncodedString() else {
            completion(false)
            print("[AuthManager] FAILURE to get base64")
            return
        }

        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")



        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }

            do {


                let result = try JSONDecoder().decode(AuthResponse.self, from: data)

                self?.cacheToken(result: result)

                completion(true)
            } catch {
                completion(false)
            }

        }.resume()
    }

    public func refreshAccessToken() {
        
    }

    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        UserDefaults.standard.setValue(result.refresh_token, forKey: "refresh_token")
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")

    }
}
