//
//  HomeViewController.swift
//  Khabar
//
//  Created by Ahmed Abdeen on 07/01/2023.
//

import UIKit
import SafariServices

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
        
    }()
    
    private let searchVC = UISearchController(searchResultsController: nil)
    private var articles = [Article]()
    private var forecastItem = [ForecastItem]()
    private var viewModels = [NewsTableViewCellViewModel]()
    private var forecastViewModels = [ForecastViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "News"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title ?? "",
                        subtitle: $0.body ?? "No description",
                        imageURL: URL(string: $0.image ?? ""),
                        date: $0.date ?? "",
                        source: $0.source?.title ?? ""
                    )
                    
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        APICaller.shared.getForecast { [weak self] result in
            switch result {
            case .success(let forecastItem):
                self?.forecastItem = forecastItem
                print("well \(forecastItem[0].day.maxtemp_c)")
                self?.forecastViewModels = forecastItem.compactMap({
                    ForecastViewModel(
                        maxtemp_c: $0.day.maxtemp_c,
                        mintemp_c: $0.day.mintemp_c,
                        avgtemp_c: $0.day.avgtemp_c
                    )
                    
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        createSearchBar()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Temp in Khartoum: \(forecastItem.count>0 ? forecastItem[0].day.avgtemp_c : 0.0)° Max: \(forecastItem.count>0 ? forecastItem[0].day.maxtemp_c : 0.0)° Min: \(forecastItem.count>0 ? forecastItem[0].day.mintemp_c : 0.0)°"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap({
                    NewsTableViewCellViewModel(
                        title: $0.title ?? "",
                        subtitle: $0.body ?? "No description",
                        imageURL: URL(string: $0.image ?? ""),
                        date: $0.date ?? "",
                        source: $0.source?.title ?? ""
                    )
                    
                })
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
//                    self?.searchVC.dismiss(animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
