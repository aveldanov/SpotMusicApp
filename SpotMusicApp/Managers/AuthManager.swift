//
//  AuthManager.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import Foundation


final class AuthManager {

    static let shared = AuthManager()
    private var refreshingToken = false


    struct Constants {
        static let  clientID = "906d20caba24486eb1a6e9014f87a5ef"
        static let clientSecret = "fc2eb44d26aa4b4b8b1df0bf3e2e5e48"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirect_uri = "https://www.google.com/"
        static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"
    }

    private init() {}

    public var signInURL: URL? {
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientID)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirect_uri)&show_dialog=TRUE"
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
                                 URLQueryItem(name: "redirect_uri", value: Constants.redirect_uri)]


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
                print("[AuthManager] token", result)
                self?.cacheToken(result: result)
                completion(true)
            } catch {
                completion(false)
            }

        }.resume()
    }

    // array of escaping closures
    private var onRefreshBlocks = [(String)->Void]()

    /// Supplies valid token to be used with API Calls
    public func withValidToken(completion: @escaping (String)->Void) {
        guard !refreshingToken else {
            //Append completion
            onRefreshBlocks.append(completion) // helps to avoid redundunt refresh
            return
        }

        if shouldRefreshToken {
            // Refresh
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            print("[AuthManager] valid token:", token)
            completion(token)
        }
    }

    public func refreshIfNeeded(completion: ((Bool)->Void)?) {
        // check if we are already refreshing
        guard !refreshingToken else {
            return
        }

        // continue

        guard shouldRefreshToken else {
            completion?(true) // token is still valid
            return
        }
        guard let refreshToken = refreshToken else {
            return
        }

        // refresh token
        guard let url = URL(string: Constants.tokenAPIURL) else {
            return
        }

        self.refreshingToken = true

        var components = URLComponents()
        components.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"),
                                 URLQueryItem(name: "refresh_token", value: refreshToken)]


        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-type")
        request.httpBody = components.query?.data(using: .utf8)

        let basicToken = Constants.clientID + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)

        guard let base64String = data?.base64EncodedString() else {
            completion?(false)
            print("[AuthManager] FAILURE to get base64")
            return
        }

        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")



        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            self?.refreshingToken = false // stopped refreshing token
            guard let data = data, error == nil else {
                completion?(false)
                return
            }

            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("[AuthManager] Successfully refreshed - refresh_token", refreshToken)
                self?.onRefreshBlocks.forEach{$0(result.access_token)}
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)

                completion?(true)
            } catch {
                completion?(false)
            }

        }.resume()
    }

    public func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
}
