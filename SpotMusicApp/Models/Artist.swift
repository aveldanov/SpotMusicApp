//
//  Artist.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 9/12/22.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
