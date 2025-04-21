//
//  ChatView.swift
//  HomeLMStudio
//
//  Created by Роман Пшеничников on 20.04.2025.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            TextField("URL к LM Studio", text: $viewModel.apiURL)
                .textFieldStyle(.roundedBorder)
                .padding()

            ScrollView {
                ForEach(viewModel.messages) { message in
                    HStack(alignment: .top) {
                        Text(message.role.capitalized + ":")
                            .bold()
                        Text(message.content)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }

                if !viewModel.streamingResponse.isEmpty {
                    HStack(alignment: .top) {
                        Text("Assistant:")
                            .bold()
                        Text(viewModel.streamingResponse)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 4)
                }
            }

            HStack {
                TextField("Ваш запрос...", text: $viewModel.inputText)
                    .textFieldStyle(.roundedBorder)
                Button("Отправить") {
                    viewModel.sendMessage()
                    viewModel.inputText = ""
                }
            }
            .padding()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
