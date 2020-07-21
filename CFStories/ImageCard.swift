//
//  ImageCard.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/20/20.
//

import SwiftUI

struct ImageCard: View {
    
    let product: Product
    let story: Story
    
    static let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            return formatter
        }()
    
    var body: some View {
        VStack {
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
        }.cornerRadius(20)
    }
}

struct ImageCard_Previews: PreviewProvider {
    static var previews: some View {
//        ImageCard(product: <#Product#>, story: <#Story#>)
        Text("hello world")
    }
}
