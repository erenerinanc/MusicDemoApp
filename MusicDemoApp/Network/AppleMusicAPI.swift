//
//  AppleMusicAPI.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 23.09.2021.
//

import Foundation
import StoreKit


enum APIError: String, Error {
    case invalidRequest = "This URL does not exist"
    case invalidData = "Data can not be converted"
    case invalidResponse = "Response is not valid"
    case unableToComplete = "Network Error"
}

struct APIRequest {
    let baseURL = "https://api.music.apple.com/v1"
    var queryItems: [URLQueryItem] {
        var itemArray: [URLQueryItem] = []
        for (name,value) in parameters {
            itemArray.append(URLQueryItem(name: name, value: value))
        }
        return itemArray
    }
    let path: String
    let parameters: [String:String]
}

protocol AppleMusicAPI {
    func fetch<T:Decodable>(request: APIRequest, model: T.Type, completion: @escaping (Result<T,APIError>) -> Void)
}

final class AppleMusicFeed: AppleMusicAPI {
    var urlSession: URLSession
    
    init(developerToken: String, userToken: String) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = [
            "Authorization": "Bearer \(developerToken)",
            "Music-User-Token": userToken
        ]
        
        urlSession = URLSession(configuration: sessionConfig)
    }
    
    func fetch<T:Decodable>(request: APIRequest, model: T.Type, completion: @escaping (Result<T,APIError>) -> Void) {
        var urlComponents = URLComponents(string: request.baseURL + request.path)!
        urlComponents.queryItems = request.queryItems
        
        var urlRequest = URLRequest(url: urlComponents.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        urlRequest.httpMethod = "GET"
        urlSession.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                print(APIError.invalidData)
                return
            }
            
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                print(APIError.unableToComplete)
                return
            } else {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(model.self, from: data)

                        DispatchQueue.main.async {
                            completion(.success(apiResponse))
                        }
                    } catch {
                        let error = error

                        DispatchQueue.main.async {
                            completion(.failure(.invalidData))
                        }
                        print("Error:", error.localizedDescription, APIError.invalidData)
                    }
                } else {
                    print("Response status code:", (response as? HTTPURLResponse)?.statusCode)
                }
            }

        }.resume()
    }
}


  
    
