//
//  PostListTests.swift
//  PostListTests
//
//  Created by Fouad Mohammed Rafique Anwar on 29/05/24.
//

import XCTest
@testable import PostList

final class PostListTests: XCTestCase {
    
    // Mock objects
    class MockDataFetcher: DataFetching {
        func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            // Read data from file
            guard let path = Bundle.main.path(forResource: "TestPostData", ofType: "json") else {
                completion(.failure(NSError(domain: "TestFileNotFound", code: -3, userInfo: nil)))
                return
            }
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                completion(.success(data))

            } catch {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
            }
        }
    }
    
    class MockErrorFetcher: DataFetching {
        func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            completion(.failure(NSError(domain: "DataError", code: -1, userInfo: nil)))
        }
    }
    
    class MockErrorParser: DataParsing {
        func parseData<T>(_ data: Data) -> Result<T, Error> where T : Decodable {
            return .failure(NSError(domain: "ParsingError", code: -2, userInfo: nil))
        }
    }
    
    class MockURLBuilder: URLBuilding {
        func makeURLForPosts(page: Int, limit: Int) -> URL? {
            // Mock implementation
            return URL(string: "https://example.com/posts?page=\(page)&limit=\(limit)")
        }
    }
    
    func testFetchPostsSuccess() {
        // Arrange
        let mockDataFetcher = MockDataFetcher()
        let mockDataParser = JSONParser()
        let mockURLBuilder = MockURLBuilder()
        let useCase = PostsUseCase(dataFetcher: mockDataFetcher, dataParser: mockDataParser, urlBuilder: mockURLBuilder)
        
        var fetchedPosts: [Post]?
        var fetchError: Error?
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch posts")
        useCase.fetchPosts(page: 1, limit: 3) { result in
            switch result {
            case .success(let posts):
                fetchedPosts = posts
            case .failure(let error):
                fetchError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertNotNil(fetchedPosts, "Fetched posts should not be nil")
        XCTAssertNil(fetchError, "Fetch error should be nil")
    }
    
    func testFetchPostsFailure() {
        // Arrange
        let mockDataFetcher = MockErrorFetcher()
        let mockDataParser = JSONParser()
        let mockURLBuilder = MockURLBuilder()
        let useCase = PostsUseCase(dataFetcher: mockDataFetcher, dataParser: mockDataParser, urlBuilder: mockURLBuilder)
        
        let expectedError = NSError(domain: "DataError", code: -1, userInfo: nil)
        var fetchError: Error?
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch posts")
        useCase.fetchPosts(page: 1, limit: 3) { result in
            switch result {
            case .success:
                break // No action needed for success case
            case .failure(let error):
                fetchError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertNotNil(fetchError, "Fetch error should not be nil")
        XCTAssertEqual((fetchError! as NSError).domain, expectedError.domain, "Fetch error domain should match")
        XCTAssertEqual((fetchError! as NSError).code, expectedError.code, "Fetch error code should match")
    }
    
    func testParsePostsFailure() {
        // Arrange
        let mockDataFetcher = MockDataFetcher()
        let mockDataParser = MockErrorParser()
        let mockURLBuilder = MockURLBuilder()
        let useCase = PostsUseCase(dataFetcher: mockDataFetcher, dataParser: mockDataParser, urlBuilder: mockURLBuilder)
        
        let expectedError = NSError(domain: "ParsingError", code: -2, userInfo: nil)
        var fetchError: Error?
        
        // Act
        let expectation = XCTestExpectation(description: "Fetch posts")
        useCase.fetchPosts(page: 1, limit: 3) { result in
            switch result {
            case .success:
                break // No action needed for success case
            case .failure(let error):
                fetchError = error
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
        
        // Assert
        XCTAssertNotNil(fetchError, "Fetch error should not be nil")
        XCTAssertEqual((fetchError! as NSError).domain, expectedError.domain, "Fetch error domain should match")
        XCTAssertEqual((fetchError! as NSError).code, expectedError.code, "Fetch error code should match")
    }
}
