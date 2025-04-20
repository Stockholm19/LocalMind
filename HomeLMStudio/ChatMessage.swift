//
//  ChatMessage.swift
//  HomeLMStudio
//
//  Created by Роман Пшеничников on 20.04.2025.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: String
    let content: String
}
