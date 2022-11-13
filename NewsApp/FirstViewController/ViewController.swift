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
    var articlesToDisplay: [Article]?
    
    let newsTableView: UITableView = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let tableView = UITableView()
        tableView.frame = CGRect(x: 0, y: 100, width: w, height: h * 0.77)
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "newsCell")
        tableView.allowsMultipleSelection = false
        return tableView
    }()
    
    let weatherButton: UIButton = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let button = UIButton()
        button.frame = CGRect(x: w * 0.05, y: h * 0.89, width: w * 0.9, height: h * 0.08)
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
    
    let searchController = UISearchController()
    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "NewsApp"
        
        DataStorage.shared.setFirstLocation()
        view.addSubview(newsTableView)
        view.addSubview(weatherButton)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        viewModel.delegate = self
        getArticles()
        
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
//        let navi = UINavigationController(rootViewController: vc)
//        vc.title = "Options"
//        navi.present(vc, animated: true, completion: nil)

//        vc.modalPresentationStyle = .popover
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
}

//MARK: - table view extension

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesToDisplay?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as!
        NewsTableViewCell
        cell.isSelected = false
        cell.contentView.backgroundColor = .white
        cell.readButton.isHidden = true
        cell.saveButton.isHidden = true
        cell.image.alpha = 1
        cell.article = articlesToDisplay?[indexPath.row]
        cell.titleLabel.text = articlesToDisplay?[indexPath.row].title
        cell.descriptionLabel.text = articlesToDisplay?[indexPath.row].content
        cell.loadImageWithNetworkingServices()
        cell.delegate = self
        
        if selectedRow == indexPath.row {
            cell.contentView.backgroundColor = .lightGray
            cell.image.alpha = 0.3
            cell.readButton.isHidden = false
            cell.saveButton.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = UIScreen.main.bounds.height
        return h * 0.2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        
        guard let cell = newsTableView.cellForRow(at: indexPath) as? NewsTableViewCell else {return}
        
        guard cell.readButton.isHidden else {
            selectedRow = nil
            cell.image.alpha = 1
            cell.readButton.isHidden = true
            cell.saveButton.isHidden = true
            cell.contentView.backgroundColor = .white
            return
        }
        selectedRow = indexPath.row
        
        cell.contentView.backgroundColor = .lightGray
        cell.image.alpha = 0.3
        cell.readButton.isHidden = false
        cell.saveButton.isHidden = false
        navigationItem.searchController?.resignFirstResponder()
        cell.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = newsTableView.cellForRow(at: indexPath) as? NewsTableViewCell else {return}
        cell.contentView.backgroundColor = .white
        cell.image.alpha = 1
        cell.readButton.isHidden = true
        cell.saveButton.isHidden = true
    }
}

//MARK: - ViewModel Delegate extension

extension ViewController: FirstViewModeleDelegate {
    
    func articlesHasBeenDownloaded(_ firstViewModel: FirstViewModelProtocol, articles: [Article]) {
        self.articlesToDisplay = articles
        newsTableView.reloadData()
        selectedRow = nil
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

