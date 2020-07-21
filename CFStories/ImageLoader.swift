//
//  ImageLoader.swift
//  CFStories
//
//  Created by Farhan Farooqui on 7/18/20.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    private var cache: ImageCache?
    @Published var image: UIImage?
    private let url: URL
    private var cancellable: AnyCancellable?

    init(url: URL) {
        self.url = url
    }
    
    func load() {
        
        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }

    init(url: URL, cache: ImageCache? = nil) {
       self.url = url
       self.cache = cache
    }
       
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
    
}

struct AsyncImage<Placeholder: View>: View {
    
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    
    init(url: URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
    }

    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
           Group {
               if loader.image != nil {
                   Image(uiImage: loader.image!)
                       .resizable()
               } else {
                   placeholder
               }
           }
       }
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
