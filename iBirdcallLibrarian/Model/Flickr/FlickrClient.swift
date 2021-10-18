//
//  FlickrClient.swift
//  iBirdcallLibrarian
//
//  Created by Jonathan Mason on 18/10/2021.
//

import Foundation
import UIKit

/// Provides access to Flickr API.
class FlickrClient {

    /// Endpoints of Flickr API.
    enum Endpoints {
        static let baseURL = "https://www.flickr.com/services/rest/?method=flickr.photos.search"
        static let apiKey = "20f97d04d53f5fed2ccbf8c5f5ceef23"

        case getPhotoURLsForLocation(Int, Double, Double)
        
        /// Construct endpoint according to current case.
        /// - Returns: Endpoint URL as string.
        func constructURL() -> String {
            switch(self) {
            case .getPhotoURLsForLocation(let page, let latitude, let longitude):
                // extras=url_t: include URL for thumbnail-sized photo (100w x 75h). (https://www.flickr.com/services/api/flickr.photos.getSizes.html).
                // nojsoncallback=1: exclude top-level function wrapper from JSON response (https://www.flickr.com/services/api/response.json.html).
            return "\(Endpoints.baseURL)&api_key=\(Endpoints.apiKey)&lat=\(latitude)&lon=\(longitude)&page=\(page)&per_page=50&format=json&nojsoncallback=1&extras=url_t"
            }
        }
        
        /// Endpoint of current case.
        /// - Returns: Endpoint URL.
        var url: URL {
            return URL(string: constructURL())!
        }
    }

    /// Send GET request to retrieve photo URLs for supplied location from Flickr API.
    /// - Parameters:
    ///   - page: Page of photos to download.
    ///   - latitude: Latitude of photo URLs to retrieve.
    ///   - longitude: Longitude of photo URLs to retrieve.
    ///   - completion: Function to call upon completion.
    class func getPhotoURLsForLocation(page: Int, latitude: Double, longitude: Double, completion: @escaping (Int, [String], Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getPhotoURLsForLocation(page, latitude, longitude).url, responseType: PhotoURLsResponse.self) { response, error in
            if let response = response {
                // Extract array of URLs from response.
                // Based on "Transforming a Dictionary with Swift Map" of "How to Use Swift Map to Transforms Arrays, Sets, and Dictionaries" by Bart Jacobs:
                // https://cocoacasts.com/swift-essentials-1-how-to-use-swift-map-to-transforms-arrays-sets-and-dictionaries
                let urls = response.photos.photo.map { $0.url }.sorted()
                
                completion(response.photos.pages, urls, nil)
            }
            else {
                completion(0, [], error)
            }
        }
    }
    
    /// Send GET request to download photo from Flickr API.
    /// - Parameters:
    ///   - url: URL of photo.
    ///   - completion: Function to call upon completion.
    class func getPhoto(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                completion(image, error)
            }
        }
        task.resume()
    }
    
    /// Send GET request.
    /// - Parameters:
    ///   - url: URL endpoint of API.
    ///   - responseType: Type of JSON response object.
    ///   - completion: Function to call upon completion.
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(responseType, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponseObject = try decoder.decode(ErrorResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponseObject)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
}
