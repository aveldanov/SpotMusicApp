//
//  SettingsModel.swift
//  SpotMusicApp
//
//  Created by Anton Veldanov on 10/2/22.
//

import Foundation


struct Section {
    let title: String
    let options: [Option]
}


struct Option {
    let title: String
    let handler: () -> Void
}
