//
//  ContentView.swift
//  XCAChatGPT
//
//  Created by Khanh Nguyen on 02/05/2023.
//

import SwiftUI

struct ContentView: View {
    let apiKey:String = "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"
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello")
        }
        .padding()
        .onAppear{
            Task{
                let api = ChatGPTApi(apiKey: apiKey)
                do {
                    let stream = try await api.sendMessageStream(text: "What is james bond")
                    for try await line in stream {
                        print(line)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
