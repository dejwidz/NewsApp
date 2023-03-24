//
//  OptionsModel.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 07/08/2022.
//

import Foundation

protocol OptionsModelProtocol: AnyObject {
    var delegate: OptionsModelDelegate? {get set}
    func toDateHasChanged(toDate: String)
    func fromDateHasChanged(fromDate: String)
    func countryHasChanged(newCountry: Countries)
    func categoryHasChanged(newCategory: Categories)
    func setStartDate(newDate: Date)
    func getStartDate()
    func setEndDate(newDate: Date)
    func getEndDate()
    func setCountryIndex(newIndex: Int)
    func getCountryIndex()
    func setCategoryIndex(newIndex: Int)
    func getCategoryIndex()
}

protocol OptionsModelDelegate: AnyObject {
    func sendStartDate(_ optionsModelProtocol: OptionsModel, date: Date?)
    func sendEndDate(_ optionsModelProtocol: OptionsModel, date: Date?)
    func sendCountryIndex(_ optionsModelProtocol: OptionsModel, index: Int)
    func sendCategoryIndex(_ optionsModelProtocol: OptionsModel, index: Int)
}

final class OptionsModel: OptionsModelProtocol {
    weak var delegate: OptionsModelDelegate?
    
    func setStartDate(newDate: Date) {
        OptionsViewData.shared.setStartDate(newDate: newDate)
    }
    
    func getStartDate() {
        delegate?.sendStartDate(self, date: OptionsViewData.shared.getStartDate())
    }
    
    func setEndDate(newDate: Date) {
        OptionsViewData.shared.setEndDate(newDate: newDate)
    }
    
    func getEndDate() {
        delegate?.sendEndDate(self, date: OptionsViewData.shared.getEndDate())
    }
    
    func setCountryIndex(newIndex: Int) {
        OptionsViewData.shared.setCountryIndex(newIndex: newIndex)
    }
    
    func getCountryIndex() {
        delegate?.sendCountryIndex(self, index: OptionsViewData.shared.getCountryIndex())
    }
    
    func setCategoryIndex(newIndex: Int) {
        OptionsViewData.shared.setCategoryIndex(newIndex: newIndex)
    }
    
    func getCategoryIndex() {
        delegate?.sendCategoryIndex(self, index: OptionsViewData.shared.getCategoryIndex())
    }
    
    func countryHasChanged(newCountry: Countries) {
        guard newCountry.rawValue != "" else {
            URLBuilder.shared.setUserIsInterestedInSpecificTopicIndicator(newIndicatorValue: false)
            return
        }
        URLBuilder.shared.setCountry(newCountry: newCountry)
        URLBuilder.shared.setUserIsInterestedInSpecificTopicIndicator(newIndicatorValue: true)
    }
    
    func categoryHasChanged(newCategory: Categories) {
        URLBuilder.shared.setCategory(newCategory: newCategory)
    }
    
    func fromDateHasChanged(fromDate: String) {
        URLBuilder.shared.setDateFrom(newDateFrom: fromDate)
    }
    
    func toDateHasChanged(toDate: String) {
        URLBuilder.shared.setDateTo(newDateTo: toDate)
    }
}
