//
//  Gif.swift
//  gif-me
//
//  Created by Raitis Saripo on 20/04/2021.
//

import Foundation

struct Gif: Codable {
    let images: GifImage?
}

struct GifImage: Codable {
    let preview_gif: GifSource?
}

struct GifSource: Codable {
    let url: String?
}

struct GifList: Codable {
    let data: [Gif]
}
