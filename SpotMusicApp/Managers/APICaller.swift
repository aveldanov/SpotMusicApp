//
//  APICaller.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import Foundation

final class APICaller {

    static let shared = APICaller()
    private init() {}

    public func getUserProfile(completion: @escaping (Result<UserProfile,Error>)->Void) {

    }
    // MARK: - Private

    enum HTTPMethod: String {
        case GET
        case POST
    }

    private func createRequest(with url: URL?,completion: @escaping (URLRequest)->Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completion(request)

        }


    }
}
