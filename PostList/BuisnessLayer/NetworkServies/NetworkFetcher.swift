//
//  NetworkService.swift
//  PostList
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import Foundation

protocol DataFetching {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkFetcher: DataFetching {
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
