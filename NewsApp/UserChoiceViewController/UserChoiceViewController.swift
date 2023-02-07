//
//  UserChoiceViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/07/2022.
//

import UIKit
import Network
import SafariServices

class UserChoiceViewController: UIViewController {
    
    let userChoiceTableView: UITableView = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .always
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UserChoiceTableViewCell.self, forCellReuseIdentifier: "userChoiceCell")
        return tableView
    }()
    
    private let viewModel = UserChoiceViewModel(model: UserChoiceModel())
    var articlesToShow: [UserChoiceArticle]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Choice"
        view.addSubview(userChoiceTableView)
        viewModel.delegate = self
        viewModel.getUserChoiceArticlesFromModel()
        userChoiceTableView.delegate = self
        userChoiceTableView.dataSource = self
        setupUserChoiceTableView()
    }
    
    override func viewWillLayoutSubviews() {
        navigationItem.backBarButtonItem?.title = "Back"
    }
    
    func setupUserChoiceTableView() {
        NSLayoutConstraint.activate([
            userChoiceTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userChoiceTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userChoiceTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userChoiceTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
}

extension UserChoiceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesToShow?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userChoiceTableView.dequeueReusableCell(withIdentifier: "userChoiceCell") as! UserChoiceTableViewCell
        cell.titleLabel.text = articlesToShow?[indexPath.row].title
        cell.descriptionLabel.text = articlesToShow?[indexPath.row].content
        cell.article = articlesToShow?[indexPath.row]
        cell.loadImageWithNetworkingServices()
        cell.readButton.isHidden = true
        cell.image.alpha = 1
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = userChoiceTableView.cellForRow(at: indexPath) as? UserChoiceTableViewCell else {return}
        cell.image.alpha = 0.3
        cell.readButton.isHidden = false
        print(UIScreen.main.bounds.height * 0.2)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = userChoiceTableView.cellForRow(at: indexPath) as? UserChoiceTableViewCell else {return}
        cell.image.alpha = 1
        cell.readButton.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        DataStorage.shared.deleteArticleFromUserChoice(articleToDelete: articlesToShow![indexPath.row])
        userChoiceTableView.beginUpdates()
        articlesToShow?.remove(at: indexPath.row)
        userChoiceTableView.deleteRows(at: [indexPath], with: .right)
        userChoiceTableView.endUpdates()
    }
}

extension UserChoiceViewController: UserChoiceTableViewCellDelegate {
    func readButtonHasBeenTapped(_ userChoiceTableViewCell: UserChoiceTableViewCell, link: String?) {
        guard let link = link else {return}
        guard let url = URL(string: link) else {return}
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
}

extension UserChoiceViewController: UserChoiceViewModelDelegate {
    func userChoiceArticlesHasBeenDownloaded(_ userchoiceViewModel: UserChoiceViewModelProtocol, articles: [UserChoiceArticle]) {
        articlesToShow = articles
        userChoiceTableView.reloadData()
    }
}
