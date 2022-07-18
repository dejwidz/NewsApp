//
//  ViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    let viewModel = FirstViewModel(model: FirstModel())
    var articlesToDisplay: [Article]? {
        didSet {
            print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
        }
    }
    
    let newsTableView: UITableView = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let tablewView = UITableView()
        tablewView.frame = CGRect(x: 0, y: 100, width: w, height: h * 0.8)
        tablewView.register(NewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
        
        return tablewView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "news"
        
        view.addSubview(newsTableView)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        viewModel.delegate = self
        
        getArticles()
    }
    
    func getArticles() {
        viewModel.getArticlesToDisplay()
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesToDisplay?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell") as!
        NewsTableViewCell
        
        cell.article = articlesToDisplay?[indexPath.row]
        cell.titleLabel.text = articlesToDisplay?[indexPath.row].title
        cell.descriptionLabel.text = articlesToDisplay?[indexPath.row].description
//        cell.loadImage()
        cell.loadImageWithNetworkingServices()
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = UIScreen.main.bounds.height
        return h * 0.2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = newsTableView.cellForRow(at: indexPath) as? NewsTableViewCell else {return}
        cell.image.alpha = 0.3
        cell.readButton.isHidden = false
        cell.saveButton.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = newsTableView.cellForRow(at: indexPath) as? NewsTableViewCell else {return}
        cell.image.alpha = 1
        cell.readButton.isHidden = true
        cell.saveButton.isHidden = true
    }
    
}

extension ViewController: FirstViewModeleDelegate {
    func articlesHasBeenDownloaded(_ firstViewModel: FirstViewModelProtocol, articles: [Article]) {
        self.articlesToDisplay = articles
        newsTableView.reloadData()
    }
    
    
}

extension ViewController: newsTableViewCellDelegate {
    func readButtonHasBeenTapped(_ newsTableViewCell: NewsTableViewCell, link: String?) {
        guard let link = link else {return}
        guard let url = URL(string: link) else {return}
        print(link)
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    func saveButtonHasBeenTapped(_ newsTableViewCell: NewsTableViewCell, link: String?) {
        newsTableView.reloadData()
    }
    
    
}
