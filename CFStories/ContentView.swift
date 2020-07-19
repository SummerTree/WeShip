//
//  ContentView.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/18/20.
//

import SwiftUI

struct Response: Codable {
    
    var products: [Product]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.products = [Product]()
        while !container.isAtEnd {
            self.products.append(try container.decode(Product.self))
        }
    }
    
    struct Product: Codable {
        let id: String
        let name: String
        let logo: String
        let stories: [Story]
    }
    
    struct Story: Codable {
        let id: String
        let productId: String
        let createdAt: String
        let thumbnailURL: String
        let videoURL: String
    }
    
}

struct ContentView: View {
    
    @State private var results = [Response.Product]()
    
    let coloums = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                Text(" \(item.id) \(item.logo) \(item.name)")
                    .font(.headline)
                Text(item.stories.first!.createdAt)
                    .font(.caption)
            }
        }
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        let url = URL(string: "https://5f135bdd0a90bd0016370721.mockapi.io/products")!
        let request = URLRequest(url: url)
        print(request)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("\(String(describing: response))")
            }
            let responseString = String(data: data, encoding: .utf8)
            guard let result = responseString else { return }
            print(result)
            let decoder = JSONDecoder()
            let responseData = try! decoder.decode(Response.self, from: data)
            self.results = responseData.products
            return
        }.resume()

    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
