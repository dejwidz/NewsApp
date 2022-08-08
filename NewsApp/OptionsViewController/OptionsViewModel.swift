//
//  OptionsViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 07/08/2022.
//

import Foundation

protocol OptionsViewModelProtocol: AnyObject {
    var delegate: OptionsViewModelDelegate? {get set}
    func toDateHasChanged(sendedDate: Date)
    func fromDateHasChanged(sendedDate: Date)
    func countrySegmentedControlHasChanged()
    func TopicsSegmentedControlHasChanged()
}

protocol OptionsViewModelDelegate: AnyObject {
    func newMaximalDateForFromDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date)
    func newMinimalDateForToDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date)
    
}

final class OptionsViewModel {
 
    weak var delegate: OptionsViewModelDelegate?
    private var model: OptionsModelProtocol
    
    init(model: OptionsModelProtocol) {
        self.model = model
        model.delegate = self
    }
    
}

extension OptionsViewModel: OptionsViewModelProtocol {
    
    func toDateHasChanged(sendedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let stringDate = dateFormatter.string(from: sendedDate)
        let maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: sendedDate)
        delegate?.newMaximalDateForFromDate(self, newDate: maximumDate!)
    }
    
    func fromDateHasChanged(sendedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let stringDate = dateFormatter.string(from: sendedDate)
        let minimalDate = Calendar.current.date(byAdding: .day, value: 1, to: sendedDate)
        delegate?.newMinimalDateForToDate(self, newDate: minimalDate!)
    }
    
    func countrySegmentedControlHasChanged() {
        
    }
    
    func TopicsSegmentedControlHasChanged() {
        
    }
    
    
}

extension OptionsViewModel: OptionsModelDelegate {
    
}
