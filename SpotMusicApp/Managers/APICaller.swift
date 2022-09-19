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
}
