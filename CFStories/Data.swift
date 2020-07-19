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
    
    struct Product: Codable, Hashable, Identifiable {
        
        static func == (lhs: Response.Product, rhs: Response.Product) -> Bool {
            return lhs.name == rhs.name
        }
        
        let id: String
        let name: String
        let logo: String
        let stories: [Story]
    }
    
    struct Story: Codable, Hashable, Identifiable {
        let id: String
        let productId: String
        let createdAt: String
        let thumbnailURL: String
        let videoURL: String
    }
    
}
