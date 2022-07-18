//
//  UserChoiceViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 17/07/2022.
//

import UIKit

class UserChoiceViewController: UIViewController {
    
    private var viewModel = UserChoiceViewModel(model: UserChoiceModel())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self

    }


    

}

extension UserChoiceViewController: UserChoiceViewModelDelegate {
    
}
