//
//  OptionsViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 07/08/2022.
//

import UIKit

class OptionsViewController: UIViewController {
    
    private var viewmodel = OptionsViewModel(model: OptionsModel())
    
    let toDate: UIDatePicker = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let datePicker = UIDatePicker()
        let now = Date.now
        
        datePicker.frame = CGRect(x: 0, y: h * 0.1, width: w * 0.8, height: h * 0.1)
        datePicker.datePickerMode = .date
        datePicker.maximumDate = now
        datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -1, to: now)
        datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(toDateChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    @objc func toDateChanged(_ sender: UIDatePicker) {
        viewmodel.toDateHasChanged(sendedDate: sender.date)
    }
    
    let fromDate: UIDatePicker = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let datePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 0, y: h * 0.2, width: w * 0.8, height: h * 0.1)
        datePicker.datePickerMode = .date
        let now = Date.now
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: now)
        datePicker.minimumDate = Calendar.current.date(byAdding: .month, value: -1, to: now)
        datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(fromDateChanged(_:)), for: .valueChanged)
        
        return datePicker
    }()
    
    @objc func fromDateChanged(_ sender: UIDatePicker) {
        viewmodel.fromDateHasChanged(sendedDate: sender.date)
    }
    
    let toDateLabel: UILabel = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let label = UILabel()
        label.frame = CGRect(x: 0, y: h * 0.07, width: w * 0.5, height: h * 0.1)
        label.text = "Select end date"
        label.textColor = UIColor.black
//        label.traitCollection.legibilityWeight = .regular
        label.textAlignment = .right
        
        return label
    }()
    
    let fromDateLabel: UILabel = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let label = UILabel()
        label.frame = CGRect(x: 0, y: h * 0.17, width: w * 0.5, height: h * 0.1)
        label.text = "Select start date"
        label.textColor = UIColor.black
//        label.traitCollection.legibilityWeight = .regular
        label.textAlignment = .right
        
        return label
    }()
    
    let countrySegmentedControl: UISegmentedControl = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let segment = UISegmentedControl(items: ["World", "US", "PL", "DE", "FR", "IT"])
        segment.frame = CGRect(x: w * 0.01, y: h * 0.3, width: w * 0.98, height: h * 0.1)
        segment.selectedSegmentIndex = 0
//        segment.tintColor = UIColor.white
//        segment.selectedSegmentTintColor = UIColor.white
        segment.backgroundColor = UIColor.black
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segment.addTarget(self, action: #selector(countrySelectedControlChanged(_:)), for: .valueChanged)
        
        return segment
    }()
    
    @objc func countrySelectedControlChanged(_ sender: UISegmentedControl) {
        
    }
    
    let topicsSegmentedControl: UISegmentedControl = {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let segment = UISegmentedControl(items: ["General", "Science", "Sport", "Bussines", "Technology"])
        segment.frame = CGRect(x: w * 0.01, y: h * 0.45, width: w * 0.98, height: h * 0.1)
        segment.selectedSegmentIndex = 0
//        segment.tintColor = UIColor.white
//        segment.selectedSegmentTintColor = UIColor.white
        segment.backgroundColor = UIColor.black
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segment.addTarget(self, action: #selector(topicsSegmentedControlChanged(_:)), for: .valueChanged)
        
        return segment
    }()
    
    @objc func topicsSegmentedControlChanged(_ sender: UISegmentedControl) {
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Options"
        viewmodel.delegate = self
        view.backgroundColor = .white
        view.addSubview(toDate)
        view.addSubview(fromDate)
        view.addSubview(toDateLabel)
        view.addSubview(fromDateLabel)
        view.addSubview(countrySegmentedControl)
        view.addSubview(topicsSegmentedControl)
        
    }
    
}

extension OptionsViewController: OptionsViewModelDelegate {
    func newMaximalDateForFromDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date) {
        fromDate.maximumDate = newDate
    }
    
    func newMinimalDateForToDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date) {
        toDate.minimumDate = newDate
    }
    
    
}
