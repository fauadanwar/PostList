//
//  PostsUseCase.swift
//  PostList
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import Foundation

protocol PostsUseCaseProtocol {
    func fetchPosts(page: Int, limit: Int, completion: @escaping (Result<[Post], Error>) -> Void)
}

class PostsUseCase: PostsUseCaseProtocol {
    private let dataFetcher: DataFetching
    private let dataParser: DataParsing
    private let urlBuilder: URLBuilding
    
    init(dataFetcher: DataFetching = NetworkFetcher(), dataParser: DataParsing = JSONParser(), urlBuilder: URLBuilding = URLBuilder()) {
        self.dataFetcher = dataFetcher
        self.dataParser = dataParser
        self.urlBuilder = urlBuilder
    }
    
    func fetchPosts(page: Int, limit: Int, completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = urlBuilder.makeURLForPosts(page: page, limit: limit) else {
            completion(.failure(NSError(domain: "NetworkError", code: -2, userInfo: nil)))
            return
        }
        
        dataFetcher.fetchData(from: url) { result in
            switch result {
            case .success(let data):
                let parseResult: Result<[Post], Error> = self.dataParser.parseData(data)
                completion(parseResult)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
