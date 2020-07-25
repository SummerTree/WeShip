//
//  Data.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/18/20.
//

import SwiftUI

struct Response: Codable, Hashable {
    
    static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.products.count == rhs.products.count
    }
    
    
    var products: [Product]
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.products = [Product]()
        while !container.isAtEnd {
            self.products.append(try container.decode(Product.self))
        }
    }
    
}

struct Product: Codable, Hashable, Identifiable {
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.name == rhs.name
    }
    
    let id: String
    let name: String
    let logo: String
    var stories: [Story]
}

struct Story: Codable, Hashable, Identifiable {
    let id: String
    let productId: String
    let createdAt: String
    let thumbnailURL: String
    let videoURL: String
    let metadata: Metadata
}

struct Metadata: Codable, Hashable {
    let pages: [Int]
}

extension Bundle {
    func decode(_ file: String) -> [Product] {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()

        guard let loaded = try? decoder.decode(Response.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded.products
    }
}
