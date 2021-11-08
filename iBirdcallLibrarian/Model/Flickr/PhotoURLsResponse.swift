//
//  PhotoURLsResponse.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import Foundation

/// Overall JSON response object for photo URLs of Flickr API.
struct PhotoURLsResponse: Codable {
    let stat: String
    let photos: PhotosResponseSubObject
}

/// Part of JSON response object for photo URLs of Flickr API.
struct PhotosResponseSubObject: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [PhotoURLResponseSubObject]
}

/// Part of JSON response object for photo URLs of Flickr API.
struct PhotoURLResponseSubObject: Codable {
    let title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case url = "url_q"
    }
}
