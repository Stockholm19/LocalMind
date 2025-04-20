//
//  ChatViewModel.swift
//  HomeLMStudio
//
//  Created by Роман Пшеничников on 20.04.2025.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText = ""
    @Published var apiURL = "http://192.168.3.241:5472/v1/chat/completions"
    @Published var streamingResponse: String = ""

    @MainActor
    func sendMessage() {
        let userMessage = ChatMessage(role: "user", content: inputText)
        messages.append(userMessage)
        streamingResponse = ""

        Task {
            do {
                let url = URL(string: apiURL)!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let body: [String: Any] = [
                    "model": "gemma-3-12b-it",
                    "messages": [["role": "user", "content": inputText]],
                    "stream": true,
                    "temperature": 0.7
                ]
                request.httpBody = try JSONSerialization.data(withJSONObject: body)

                let (stream, _) = try await URLSession.shared.bytes(for: request)
                var responseText = ""

                for try await line in stream.lines {
                    guard line.starts(with: "data:") else { continue }
                    let jsonString = line.replacingOccurrences(of: "data: ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    if jsonString == "[DONE]" { break }

                    if let jsonData = jsonString.data(using: .utf8),
                       let delta = try? JSONDecoder().decode(StreamChunk.self, from: jsonData),
                       let chunk = delta.choices.first?.delta.content {
                        responseText += chunk
                        streamingResponse = responseText
                    }
                }

                messages.append(ChatMessage(role: "assistant", content: responseText))
                streamingResponse = ""
                inputText = ""

            } catch {
                print("Ошибка при отправке или получении ответа: \(error)")
            }
        }
    }
}

// MARK: - OpenAI совместимая структура ответа
struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}


