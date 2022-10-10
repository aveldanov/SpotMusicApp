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

    struct Constants {
        static let baseAPIURL = "https://api.spotify.com/v1"
    }

    enum APIError: Error {
        case failedToGetData
    }

    public func getUserProfile(completion: @escaping (Result<UserProfile,Error>)->Void) {
        createRequest(
            with: URL(string: Constants.baseAPIURL + "/me"),
            type: .GET) { baseRequest in
                URLSession.shared.dataTask(with: baseRequest) { data, response, error in
                    guard let data = data, error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }

                    do {
                        let result = try JSONDecoder().decode(UserProfile.self, from: data)
                        print("[APICaller getUserProfile] success")
                        completion(.success(result))
                    } catch {
                        print("[APICaller getUserProfile] failure", error.localizedDescription)
                        completion(.failure(error))
                    }
                }.resume()
            }
    }

    public func getNewReleases(completion: @escaping (Result<String, Error>)->Void) {
        createRequest(with: URL(string: Constants.baseAPIURL+"/browse/new-releases?limit=1"), type: .GET) { request in
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("[APICaller getNewReleases] failure", error?.localizedDescription)
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                print("[APICaller getNewReleases] success data", data)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("[APICaller getNewReleases] success json", json)
                } catch {
                    print("[APICaller getNewReleases] failure", error.localizedDescription)
                    completion(.failure(error))
                }

            }.resume()
        }
    }

    // MARK: - Private

    enum HTTPMethod: String {
        case GET
        case POST
    }

    private func createRequest(with url: URL?,
                               type: HTTPMethod,
                               completion: @escaping (URLRequest)->Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            print("[APICaller createRequest] success")
            completion(request)
        }
    }
}
