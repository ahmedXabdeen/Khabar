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
        static let forecast = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=18c47f10f913491cb29213100230701&q=Khartoum&days=1&aqi=no&alerts=no")
        
        static let searchURLstringFst = "https://www.newsapi.ai/api/v1/article/getArticles?query=%7B%22%24query%22%3A%7B%22%24and%22%3A%5B%7B%22keyword%22%3A%22"
        static let secondSearchURLstring = "%22%2C%22keywordLoc%22%3A%22body%22%7D%2C%7B%22locationUri%22%3A%22http%3A%2F%2Fen.wikipedia.org%2Fwiki%2FSudan%22%7D%2C%7B%22lang%22%3A%22eng%22%7D%5D%7D%2C%22%24filter%22%3A%7B%22forceMaxDataTimeWindow%22%3A%2231%22%7D%7D&resultType=articles&articlesSortBy=date&articlesCount=100&articleBodyLen=256&apiKey=1067c479-7a25-490d-b19c-e7118091068a"
    }
    
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
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
    
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchURLstringFst + query.replacingOccurrences(of: " ", with: "%20") + Constants.secondSearchURLstring
        guard let url = URL(string: urlString) else {
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
    
    public func getForecast(completion: @escaping (Result<[ForecastItem], Error>) -> Void) {
        guard let url = Constants.forecast else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) {data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(ForecastResponse.self, from: data)
                    print("Articles: \(result.forecast.forecastday.count)")
                    completion(.success(result.forecast.forecastday))
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

struct ForecastResponse: Codable {
    let current: CurrentTemp
    let forecast: ForecastDay
}

struct CurrentTemp: Codable {
    let temp_c: Float
}

struct ForecastDay: Codable {
    let forecastday: [ForecastItem]
}

struct ForecastItem: Codable {
    let day: ForecastDayObject
}

struct ForecastDayObject: Codable {
    let maxtemp_c: Float
    let mintemp_c: Float
    let avgtemp_c: Float
}

struct APIResponse: Codable {
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
