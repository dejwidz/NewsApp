////
//  ViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 15/07/2022.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    private let viewModel = FirstViewModel(model: FirstModel())
    private var articlesToDisplay: [Article]?
    private let searchController = UISearchController()
    private var imageDataHolders: [ImageHolder]?
    
    let newsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.isDirectionalLockEnabled = true
        return tableView
    }()
    
    let weatherButton: UIButton = {
        let button = UIButton()
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.white
        button.layer.borderWidth = CGFloat(w * 0.01)
        button.layer.borderColor = UIColor.black.cgColor
        button.setTitle("Check weather", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = h * 0.025
        button.titleLabel?.layer.cornerRadius = h * 0.025
        button.addTarget(self, action: #selector(weatherButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func weatherButtonTapped(_ sender: UIButton) {
        viewModel.setWeatherIndicator(weatherIndicator: true)
        let vc = LocationSettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NewsApp"
        
        DataStorage.shared.setFirstLocation()
        setupInterface()
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.prefetchDataSource = self
        viewModel.delegate = self
        getArticles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.setWeatherIndicator(weatherIndicator: false)
    }
    
    
    @objc func myChoiceButtonTapped() {
        let vc = UserChoiceViewController()
        present(vc, animated: true)
    }
    
    @objc func optionsButtonTapped() {
        let vc = OptionsViewController()
        vc.delegate = self
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func getArticles() {
        viewModel.getArticlesToDisplay()
    }
    
    func scrollUp() {
        guard newsTableView.numberOfRows(inSection: 0) > 0 else {return}
        let index = NSIndexPath(row: 0, section: 0)
        newsTableView.scrollToRow(at: index as IndexPath, at: .top, animated: true)
    }
    
    func setupImageHolders(longitude: Int) {
        imageDataHolders = []
        
        guard longitude > 1 else {return}
        
        for i in 0...longitude - 1 {
            imageDataHolders?.append(ImageHolder(imageURL: articlesToDisplay![i].urlToImage ?? ""))
            imageDataHolders![i].id = i
        }
    }
    
    func setupInterface() {
        let h = UIScreen.main.bounds.height
        
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "My choice", style: .plain, target: self, action: #selector(myChoiceButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Options", style: .plain, target: self, action: #selector(optionsButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationController?.navigationItem.searchController = searchController
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = true
        searchController.searchBar.placeholder = "type what you are interested in"
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(newsTableView)
        view.addSubview(weatherButton)
    
        NSLayoutConstraint.activate([

            newsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            newsTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: weatherButton.topAnchor, constant: -1),
            
            weatherButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            weatherButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            weatherButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherButton.heightAnchor.constraint(equalToConstant: h * 0.1)
        ])
    }
}

//MARK: - table view extension

extension ViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesToDisplay?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as!
        NewsTableViewCell
        cell.article = articlesToDisplay?[indexPath.row]
        cell.titleLabel.text = articlesToDisplay?[indexPath.row].title
        cell.descriptionLabel.text = articlesToDisplay?[indexPath.row].content
        cell.delegate = self
        
        guard let image = imageDataHolders?[indexPath.row].cachedImage else {
            cell.loadImageWithNetworkingServices()
            return cell
        }
        
        cell.image.image = image
        cell.setImageHolder(imageHolder: imageDataHolders![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = newsTableView.cellForRow(at: indexPath) as? NewsTableViewCell else {return}

            cell.readButton.isHidden = false
            cell.saveButton.isHidden = false
            cell.image.alpha = 0.6
            newsTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        guard let cell = newsTableView.cellForRow(at: indexPath) as? NewsTableViewCell else {return}
        cell.contentView.backgroundColor = UIColor.white
        cell.image.alpha = 1
        cell.readButton.isHidden = true
        cell.saveButton.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for ip in indexPaths {
            let imageHolder = imageDataHolders![ip.row]
            imageHolder.imageURL = articlesToDisplay![ip.row].urlToImage
            imageHolder.id = ip.row
            imageHolder.downloadImage()
        }
    }
    
}

//MARK: - ViewModel Delegate extension

extension ViewController: FirstViewModeleDelegate {
    
    func articlesHasBeenDownloaded(_ firstViewModel: FirstViewModelProtocol, articles: [Article]) {
        self.articlesToDisplay = articles
        newsTableView.reloadData()
        setupImageHolders(longitude: articlesToDisplay!.count)
//        selectedRow = nil
        navigationController?.navigationItem.searchController?.searchBar.resignFirstResponder()
        scrollUp()
    }
}

//MARK: - cell Delegate extension

extension ViewController: newsTableViewCellDelegate {
    func saveButtonHasBeenTapped(_ newsTableViewCell: NewsTableViewCell, article: Article?) {
        DataStorage.shared.addUserChoiceArticle(newArticle: article!)
    }
    
    func readButtonHasBeenTapped(_ newsTableViewCell: NewsTableViewCell, link: String?) {
        guard let link = link else {return}
        guard let url = URL(string: link) else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

//MARK: - searching extension

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let temporaryString = searchController.searchBar.text
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            if temporaryString == searchController.searchBar.text {
                self.viewModel.searchTextHasChanged(newText: searchController.searchBar.text!)
            }
        }
    }
}

//MARK: - OptionsViewController Delegate extension

extension ViewController: OptionsDelegate {
    func newOptionsHasBeenSet(_ optionsViewController: OptionsViewController) {
        getArticles()
    }
}

