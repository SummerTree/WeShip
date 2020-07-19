//
//  ContentView.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/18/20.
//

import SwiftUI
import AVKit

struct ContentView: View {
    
    @State private var productsData = [Response.Product]()
    @State private var cardIsExpanded: Bool = false
    @State private var selectedStory = [Response.Story]()
    
    let columns = [
        GridItem(.flexible(minimum: 24)),
        GridItem(.flexible(minimum: 24))
    ]
    
    static let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()
    
    var today = Date()

    var body: some View {
        NavigationView {
            if cardIsExpanded {
                VideoPlayer(player: AVPlayer(url:  URL(string: self.selectedStory.first!.videoURL)!))
            }
            else {
                ScrollView(.vertical) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 24) {
                    ForEach(self.productsData) { product in
                        ForEach(product.stories) { story in
                            VStack{
                                ZStack(alignment: .bottomLeading) {
                                    AsyncImage(
                                        url: URL(string: story.thumbnailURL)!,
                                        placeholder: Text("☁️").font(.largeTitle))
                                            .aspectRatio(contentMode: .fit)
                                    Rectangle()
                                        .fill(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .top))
                                        .opacity(0.65)
                                    VStack(alignment: HorizontalAlignment.leading, spacing: 4.0) {
                                        HStack {
                                            Text(product.name)
                                                .foregroundColor(.white)
                                                .font(.system(.title3, design: .rounded))
                                                .fontWeight(.heavy)
                                        }
                                        HStack {
                                            Image(systemName: "play.circle.fill")
                                                .foregroundColor(.yellow)
                                            Text("\(Calendar.current.dateComponents([.day], from: Self.taskDateFormat.date(from: story.createdAt)!, to: Date()).day!) days ago")
                                                .foregroundColor(Color(UIColor.lightGray))
                                                .fontWeight(.heavy)
                                        }
                                        .font(.system(.caption2, design: .monospaced))
                                    }
                                    .padding(.leading)
                                    .padding(.bottom)
                                    }
                                }
                                .cornerRadius(25) // zstack
                                .onTapGesture {
                                    HapticFeedback.playSelection()
                                    withAnimation {
                                        self.selectedStory.append(story)
                                        self.cardIsExpanded.toggle()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("WeShip")
        .onAppear(perform: {loadData()})
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
            return
        }.resume()

    }
   
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
