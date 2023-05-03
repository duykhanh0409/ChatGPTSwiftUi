//
//  ChatGPTApi.swift
//  XCAChatGPT
//
//  Created by Khanh Nguyen on 03/05/2023.
//

import Foundation

class ChatGPTApi{
    private let apiKey:String
    private let urlSection = URLSession.shared
    private var urlRequest: URLRequest {
        let url = URL(string: "https://api.openai.com/v1/completions")!
        var urlRequest = URLRequest(url: url)
        headers.forEach{urlRequest.setValue($1, forHTTPHeaderField: $0)}
        return urlRequest
    }
    
    private let jsonDecoder = JSONDecoder()
    private let basePrompt = "Prompt design isn’t the only tool you have at your disposal. You can also control completions by adjusting your settings. One of the most important settings is called temperature."
    private var headers: [String: String] {
        [
            "Content-Type": "Application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
    }

    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    private func generateChatGPTPrompt(from text:String) ->String {
        return basePrompt + "User: \(text)\n\n\nChatGPT"
    }
    
    private func jsonBody(text: String, stream: Bool = true) throws -> Data{
        let jsonBody: [String: Any] = [
            "model" : "text-chat-davinci-002-20230126",
            "temperature" : 0.5,
            "max_tokens": 1024,
            "prompt" : generateChatGPTPrompt(from: text),
            "stop":[
                "\n\n\n",
                "<|im_end|>"
            ],
            "stream":stream
            
        ]
        return try JSONSerialization.data(withJSONObject: jsonBody)
    }
    
    func sendMessageStream(text: String) async throws -> AsyncThrowingStream<String,Error>{
        var urlRequest = self.urlRequest
        urlRequest.httpBody = try jsonBody(text: text)
        
      
        
        let (result, response) = try await urlSection.bytes(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
            
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.badRequest
        }
        
        return AsyncThrowingStream<String, Error> {continuation in
            Task(priority: .userInitiated) {
                do {
                    for try await line in result.lines {
                        continuation.yield(line)
                        continuation.finish()
                    }
                }catch {
                    continuation.finish(throwing: error)
                }
            }
            
        }
        
    }
}

enum NetworkError: Error {
    case unauthorised
    case timeout
    case serverError
    case invalidResponse
    case badRequest
}
