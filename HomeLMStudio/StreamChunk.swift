//
//  StreamChunk.swift
//  HomeLMStudio
//
//  Created by Роман Пшеничников on 20.04.2025.
//

struct StreamChunk: Codable {
    struct Choice: Codable {
        struct Delta: Codable {
            let content: String?
        }
        let delta: Delta
    }
    let choices: [Choice]
}
