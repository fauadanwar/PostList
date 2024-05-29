//
//  URLBuilder.swift
//  PostList
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import Foundation

protocol URLBuilding {
    func makeURLForPosts(page: Int, limit: Int) -> URL?
}

struct URLBuilder: URLBuilding {
    func makeURLForPosts(page: Int, limit: Int) -> URL? {
        let urlString = "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)"
        return URL(string: urlString)
    }
}
