//
//  ContentView.swift
//  Programming Jokes
//
//  Created by Student on 2/17/21.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAlert = false
    @State private var jokes = [Joke]()
    var body: some View {
        NavigationView {
            List(jokes){ joke in
                NavigationLink(
                    destination:Text(joke.punchline)
                        .padding(),
                    label: {
                        Text(joke.setup)
                    })
            }
            .navigationTitle("Programming Jokes")
        }
        .onAppear(perform: {
            getJokes()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Effect"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("Ok")))
        })
    }
    
    func getJokes() {
        let apiKey = "?rapidapi-key=f85e60ae43mshae649811fe5b185p147232jsn0490791bc83a"
        let query = "https://dad-jokes.p.rapidapi.com/joke/type/programming\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                if json["success"] == true {
                    let contents = json["body"].arrayValue
                    for item in contents {
                        let setup = item["setup"].stringValue
                        let punchline = item["punchline"].stringValue
                        let joke = Joke(setup: setup, punchline: punchline)
                        jokes.append(joke)
                    }
                    return
                }
            }
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Joke: Identifiable {
    let id = UUID()
    var setup: String
    var punchline: String
}
