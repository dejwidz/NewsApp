//
//  OptionsViewModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 07/08/2022.
//

import Foundation

protocol OptionsViewModelProtocol: AnyObject {
    var delegate: OptionsViewModelDelegate? {get set}
    func toDateHasChanged(sentDate: Date)
    func fromDateHasChanged(sentDate: Date)
    func countrySegmentedControlHasChanged(index: Int)
    func TopicsSegmentedControlHasChanged(index: Int)
    func setStartDate(newDate: Date)
    func getStartDate()
    func setEndDate(newDate: Date)
    func getEndDate()
    func setCountryIndex(newIndex: Int)
    func getCountryIndex()
    func setCategoryIndex(newIndex: Int)
    func getCategoryIndex()
}

protocol OptionsViewModelDelegate: AnyObject {
    func newMaximalDateForFromDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date)
    func newMinimalDateForToDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date)
    func sendStartDate(_ optionsViewModelProtocol: OptionsViewModel, date: Date?)
    func sendEndDate(_ optionsViewModelProtocol: OptionsViewModel, date: Date?)
    func sendCountryIndex(_ optionsViewModelProtocol: OptionsViewModel, index: Int)
    func sendCategoryIndex(_ optionsViewModelProtocol: OptionsViewModel, index: Int)
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
    func setStartDate(newDate: Date) {
        model.setStartDate(newDate: newDate)
    }
    
    func getStartDate() {
        model.getStartDate()
    }
    
    func setEndDate(newDate: Date) {
        model.setEndDate(newDate: newDate)
    }
    
    func getEndDate() {
        model.getEndDate()
    }
    
    func setCountryIndex(newIndex: Int) {
        model.setCountryIndex(newIndex: newIndex)
    }
    
    func getCountryIndex() {
        model.getCountryIndex()
    }
    
    func setCategoryIndex(newIndex: Int) {
        model.setCategoryIndex(newIndex: newIndex)
    }
    
    func getCategoryIndex() {
        model.getCategoryIndex()
    }
    
    func toDateHasChanged(sentDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let stringDate = dateFormatter.string(from: sentDate)
        let maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: sentDate)
        delegate?.newMaximalDateForFromDate(self, newDate: maximumDate!)
        model.toDateHasChanged(toDate: stringDate)
    }
    
    func fromDateHasChanged(sentDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let stringDate = dateFormatter.string(from: sentDate)
        let minimalDate = Calendar.current.date(byAdding: .day, value: 1, to: sentDate)
        delegate?.newMinimalDateForToDate(self, newDate: minimalDate!)
        model.fromDateHasChanged(fromDate: stringDate)
    }
    
    func countrySegmentedControlHasChanged(index: Int) {
        switch index {
        case 0:
            model.countryHasChanged(newCountry: .world )
        case 1:
            model.countryHasChanged(newCountry: .usa)
        case 2:
            model.countryHasChanged(newCountry: .poland)
        case 3:
            model.countryHasChanged(newCountry: .germany)
        case 4:
            model.countryHasChanged(newCountry: .france)
        case 5:
            model.countryHasChanged(newCountry: .italy)
        default:
            print("nothing")
        }
    }
    
    func TopicsSegmentedControlHasChanged(index: Int) {
        switch index {
        case 0:
            model.categoryHasChanged(newCategory: .general)
        case 1:
            model.categoryHasChanged(newCategory: .science)
        case 2:
            model.categoryHasChanged(newCategory: .sport)
        case 3:
            model.categoryHasChanged(newCategory: .business)
        case 4:
            model.categoryHasChanged(newCategory: .technology)
        default:
            print("nothing")
        }
    }
}

extension OptionsViewModel: OptionsModelDelegate {
    func sendStartDate(_ optionsModelProtocol: OptionsModel, date: Date?) {
        delegate?.sendStartDate(self, date: date)
    }
    
    func sendEndDate(_ optionsModelProtocol: OptionsModel, date: Date?) {
        delegate?.sendEndDate(self, date: date)
    }
    
    func sendCountryIndex(_ optionsModelProtocol: OptionsModel, index: Int) {
        delegate?.sendCountryIndex(self, index: index)
    }
    
    func sendCategoryIndex(_ optionsModelProtocol: OptionsModel, index: Int) {
        delegate?.sendCategoryIndex(self, index: index)
    }
}
