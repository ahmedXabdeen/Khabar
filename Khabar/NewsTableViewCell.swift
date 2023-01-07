//
//  NewsTableViewCell.swift
//  Khabar
//
//  Created by Ahmed Abdeen on 07/01/2023.
//

import UIKit

class ForecastViewModel {
    let maxtemp_c: Float
    let mintemp_c: Float
    let avgtemp_c: Float
    
    init(maxtemp_c: Float, mintemp_c: Float, avgtemp_c: Float) {
        self.maxtemp_c = maxtemp_c
        self.mintemp_c = mintemp_c
        self.avgtemp_c = avgtemp_c
    }
}

class NewsTableViewCellViewModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    let date: String
    let source : String
    var imageData: Data?
    
    init(title: String, subtitle: String, imageURL: URL?, date: String, source: String, imageData: Data? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.date = date
        self.source = source
        self.imageData = imageData
    }
}

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"
    
    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let newsDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let newsSourceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsDateLabel)
        contentView.addSubview(newsSourceLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 20,
            height: 50
        )
        
        newsImageView.frame = CGRect(
            x: 10,
            y: 50,
            width: contentView.frame.size.width - 20,
            height: contentView.frame.size.height*0.4
        )
        
        newsDateLabel.frame = CGRect(
            x: contentView.frame.size.width - 107,
            y: 160,
            width: contentView.frame.size.width - 20,
            height: 50
        )
        
        newsSourceLabel.frame = CGRect(
            x: 10,
            y: 160,
            width: contentView.frame.size.width - 20,
            height: 50
        )

        subtitleLabel.frame = CGRect(
            x: 10,
            y: 190,
            width: contentView.frame.size.width - 20,
            height: 100
        )
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        newsDateLabel.text = nil
        newsSourceLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        newsDateLabel.text = viewModel.date
        newsSourceLabel.text = viewModel.source
        subtitleLabel.text = viewModel.subtitle
        // image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            // fetch
            URLSession.shared.dataTask(with: url) {
                data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self.newsImageView.image = UIImage(data: data)
                }
                
            }.resume()
        }
    }
}
