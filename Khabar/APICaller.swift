//
//  APICaller.swift
//  Khabar
//
//  Created by Ahmed Abdeen on 07/01/2023.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://www.newsapi.ai/api/v1/article/getArticles?query=%7B%22%24query%22%3A%7B%22%24and%22%3A%5B%7B%22locationUri%22%3A%22http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FKhartoum%22%7D%2C%7B%22lang%22%3A%22eng%22%7D%5D%7D%2C%22%24filter%22%3A%7B%22forceMaxDataTimeWindow%22%3A%2231%22%7D%7D&resultType=articles&articlesSortBy=date&articlesCount=100&articleBodyLen=256&apiKey=1067c479-7a25-490d-b19c-e7118091068a")
    }
    
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        print("fgfhfhhfnfhfhj")
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.results.count)")
                    completion(.success(result.articles.results))
                }
                catch {
                    print("something went wrong")
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

struct APIResponse:Codable {
    let articles: AResult
}

struct AResult: Codable {
    let results: [Article]
}

struct Article: Codable {
    let title: String?
    let body: String?
    let url: String?
    let image: String?
    let date: String?
    let source: Source?
}

struct Source:Codable {
    let title: String
}
