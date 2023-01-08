//
//  AboutViewController.swift
//  Khabar
//
//  Created by Ahmed Abdeen on 07/01/2023.
//

import UIKit

class AboutViewController: UIViewController {
    private let aboutLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Khabar v0.1"
        return label
    }()
    private let byLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.text = "Developed by Ahmed Abdeen 07/01/2023"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.title = "About"
        view.addSubview(aboutLabel)
        view.addSubview(byLabel)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        aboutLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: view.frame.width,
            height: view.frame.height*0.5
        )
        byLabel.frame = CGRect(
            x: 10,
            y: view.frame.height*0.5,
            width: view.frame.width,
            height: view.frame.height*0.5
        )
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
