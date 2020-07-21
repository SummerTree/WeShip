//
//  ContentView.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/18/20.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var productsData = [Product]()
    @State private var cardIsExpanded: Bool = false
    @State private var selectedStory = [Story]()
    @State private var allStories = [Story]()
    
    @Environment(\.imageCache) var cache: ImageCache
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let playerLayer = AVPlayerLayer()
        
    var today = Date()

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                GridViewHeader()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(productsData) { product in
                            ForEach(product.stories) { story in
                               ImageCard(product: product, story: story)
                                .onTapGesture {
                                    
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .navigationTitle("WeShip")
        }
        .onAppear {
            loadData()
        }
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
            self.productsData = responseData.products
            responseData.products.forEach({self.allStories.append(contentsOf: $0.stories)})
            return
        }.resume()

    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
