//
//  ContentView.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/18/20.
//

import SwiftUI
import AVKit

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(lineWidth: 5.0)
                .opacity(0.3)
                .foregroundColor(Color.white)
        }
    }
}

struct ContentView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @State private var productsData = [Product]()
    @State private var expanded: Bool = false
    @State private var selectedStory = [Story]()
    @State private var allStories = [Story]()
    @State private var playVideo: Bool = true
    @State private var time: CMTime = .zero
    @State private var progressValue: Float = 22.0
    @State private var timerObjects = [StoryTimer]()
    
    var imageNames:[String] = ["image01","image02","image03","image04"]

    @Environment(\.imageCache) var cache: ImageCache
    @ObservedObject var storyTimer: StoryTimer = StoryTimer(items: 4, interval: 4.0)
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
            
    var body: some View {
        NavigationView {
            VStack() {
                GridViewHeader()
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(productsData) { product in
                            ForEach(product.stories) { story in
                                   ImageCard(product: product, story: story)
                                    .scaleEffect(0.95)
                                    .onTapGesture {
                                        expanded.toggle()
                                    }
                                    .sheet(isPresented: $expanded) {
//                                        VideoPlayerContainerView(story: story, items: story.metadata.pages.count)
                                        WelcomeVideoController(url: URL(string: story.videoURL)!)
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
//            loadData()
            self.productsData = Bundle.main.decode("mockData.json")
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
