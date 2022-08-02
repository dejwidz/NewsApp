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
        tableView.frame = CGRect(x: 0, y: 44, width: w, height: h)
        tableView.register(UserChoiceTableViewCell.self, forCellReuseIdentifier: "userChoiceCell")
        
        
        return tableView
    }()
    
    private var viewModel = UserChoiceViewModel(model: UserChoiceModel())
    
    var articlesToShow: [UserChoiceArticle]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Choice"
        
        view.addSubview(userChoiceTableView)
        viewModel.delegate = self
        userChoiceTableView.delegate = self
        userChoiceTableView.dataSource = self
        
        
    }
    
    override func viewWillLayoutSubviews() {
        navigationItem.backBarButtonItem?.title = "Back"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        articlesToShow = DataStorage.shared.getUserChoiceArticles()
    }
    
    
}

extension UserChoiceViewController: UserChoiceViewModelDelegate {
    
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
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let h = UIScreen.main.bounds.height
        return h * 0.2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = userChoiceTableView.cellForRow(at: indexPath) as? UserChoiceTableViewCell else {return}
        cell.image.alpha = 0.3
        cell.readButton.isHidden = false
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

