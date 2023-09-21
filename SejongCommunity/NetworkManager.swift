//
//  NetworkManager.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/21.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func sendGETRequest(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string:  urlString){
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    completion(.success(data))
                } else{
                    completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                }
            }
            task.resume()
        }else{
            completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
        }
    }
    func sendPOSTRequest(urlString: String, parameters: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                do {
                    let body = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    request.httpBody = body
                } catch {
                    completion(.failure(error))
                    return
                }
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(NSError(domain: "NoData", code: 0, userInfo: nil)))
                    }
                }
                task.resume()
            } else {
                completion(.failure(NSError(domain: "InvalidURL", code: 0, userInfo: nil)))
            }
        }
}
