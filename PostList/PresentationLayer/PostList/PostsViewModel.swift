//
//  PostsViewModel.swift
//  PostList
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import Foundation

class PostsViewModel: ObservableObject {
    private let postsUseCase: PostsUseCaseProtocol
    private var currentPage = 1
    private let limit = 10
    private var isLoading = false
    @Published var posts: [Post] = []
    
    init(postsUseCase: PostsUseCaseProtocol = PostsUseCase()) {
        self.postsUseCase = postsUseCase
    }
    
    func fetchModels() {
        guard !isLoading else { return }
        isLoading = true
        
        postsUseCase.fetchPosts(page: currentPage, limit: limit) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let posts):
                self.posts.append(contentsOf: posts)
                self.currentPage += 1
            case .failure(let error):
                print("Failed to fetch posts: \(error)")
            }
        }
    }
}
