//
//  OptionsViewController.swift
//  NewsApp
//
//  Created by Dawid Zimoch on 07/08/2022.
//

import UIKit

protocol OptionsDelegate: AnyObject {
    func newOptionsHasBeenSet(_ optionsViewController: OptionsViewController)
}

class OptionsViewController: UIViewController {
    
    private var viewmodel = OptionsViewModel(model: OptionsModel())
    weak var delegate: OptionsDelegate?
    
    let toDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        let now = Date.now
        datePicker.datePickerMode = .date
        datePicker.maximumDate = now
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -29, to: now)
        datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(toDateChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    @objc func toDateChanged(_ sender: UIDatePicker) {
        viewmodel.toDateHasChanged(sendedDate: sender.date)
        viewmodel.setEndDate(newDate: sender.date)
    }
    
    let fromDate: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let now = Date.now
        datePicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: now)
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -30, to: now)
        datePicker.sizeToFit()
        datePicker.addTarget(self, action: #selector(fromDateChanged(_:)), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    @objc func fromDateChanged(_ sender: UIDatePicker) {
        viewmodel.fromDateHasChanged(sendedDate: sender.date)
        viewmodel.setStartDate(newDate: sender.date)
    }
    
    let toDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Select end date"
        label.textColor = UIColor.black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let fromDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Select start date"
        label.textColor = UIColor.black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let countrySegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["World", "US", "PL", "DE", "FR", "IT"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor.black
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segment.addTarget(self, action: #selector(countrySelectedControlChanged(_:)), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    @objc func countrySelectedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewmodel.countrySegmentedControlHasChanged(index: index)
        viewmodel.setCountryIndex(newIndex: index)
    }
    
    let topicsSegmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["General", "Science", "Sport", "Bussines", "Technology"])
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor.black
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        segment.addTarget(self, action: #selector(topicsSegmentedControlChanged(_:)), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    @objc func topicsSegmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        viewmodel.TopicsSegmentedControlHasChanged(index: index)
        viewmodel.setCategoryIndex(newIndex: index)
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
        setupInterface()
    }
    
    func setupInterface() {
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            toDateLabel.topAnchor.constraint(equalTo: view.topAnchor),
            toDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: w * 0.05),
            toDateLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            toDateLabel.heightAnchor.constraint(equalToConstant: h * 0.1),
            
            toDate.topAnchor.constraint(equalTo: toDateLabel.topAnchor),
            toDate.leadingAnchor.constraint(equalTo: toDateLabel.trailingAnchor, constant: 5),
            toDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(w * 0.1)),
            toDate.heightAnchor.constraint(equalTo: toDateLabel.heightAnchor),
            
            fromDateLabel.topAnchor.constraint(equalTo: toDateLabel.bottomAnchor),
            fromDateLabel.leadingAnchor.constraint(equalTo: toDateLabel.leadingAnchor),
            fromDateLabel.widthAnchor.constraint(equalTo: toDateLabel.widthAnchor),
            fromDateLabel.heightAnchor.constraint(equalTo: toDateLabel.heightAnchor),
            
            fromDate.topAnchor.constraint(equalTo: fromDateLabel.topAnchor),
            fromDate.leadingAnchor.constraint(equalTo: toDate.leadingAnchor),
            fromDate.widthAnchor.constraint(equalTo: toDate.widthAnchor),
            fromDate.heightAnchor.constraint(equalTo: toDate.heightAnchor),
            
            countrySegmentedControl.topAnchor.constraint(equalTo: fromDateLabel.bottomAnchor),
            countrySegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: w * 0.01),
            countrySegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(w * 0.01)),
            countrySegmentedControl.heightAnchor.constraint(equalTo: toDateLabel.heightAnchor),
            
            topicsSegmentedControl.topAnchor.constraint(equalTo: countrySegmentedControl.bottomAnchor, constant: h * 0.03),
            topicsSegmentedControl.leadingAnchor.constraint(equalTo: countrySegmentedControl.leadingAnchor),
            topicsSegmentedControl.widthAnchor.constraint(equalTo: countrySegmentedControl.widthAnchor),
            topicsSegmentedControl.heightAnchor.constraint(equalTo: countrySegmentedControl.heightAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewmodel.getEndDate()
        viewmodel.getStartDate()
        viewmodel.getCountryIndex()
        viewmodel.getCategoryIndex()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.newOptionsHasBeenSet(self)
    }
}

extension OptionsViewController: OptionsViewModelDelegate {
    func sendStartDate(_ optionsViewModelProtocol: OptionsViewModel, date: Date?) {
        guard let date = date else {return}
        fromDate.date = date
    }
    
    func sendEndDate(_ optionsViewModelProtocol: OptionsViewModel, date: Date?) {
        guard let date = date else {return}
        toDate.date = date
    }
    
    func sendCountryIndex(_ optionsViewModelProtocol: OptionsViewModel, index: Int) {
        countrySegmentedControl.selectedSegmentIndex = index
    }
    
    func sendCategoryIndex(_ optionsViewModelProtocol: OptionsViewModel, index: Int) {
        topicsSegmentedControl.selectedSegmentIndex = index
    }
    
    func newMaximalDateForFromDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date) {
        fromDate.maximumDate = newDate
    }
    
    func newMinimalDateForToDate(_ optionsViewModel: OptionsViewModelProtocol, newDate: Date) {
        toDate.minimumDate = newDate
    }
}
