//
//  JSONParser.swift
//  PostList
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import Foundation

protocol DataParsing {
    func parseData<T: Decodable>(_ data: Data) -> Result<T, Error>
}

class JSONParser: DataParsing {
    func parseData<T: Decodable>(_ data: Data) -> Result<T, Error> {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedData)
        } catch let error {
            return .failure(error)
        }
    }
}
