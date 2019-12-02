//
//  SettingsViewController.swift
//  MyMemo
//
//  Created by Cistudent on 11/25/19.
//  Copyright © 2019 Cistudent. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let sortOrderItems: Array<String> = ["low", "high", "memo_date"]
    @IBOutlet weak var pickSortField: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickSortField.dataSource = self
        pickSortField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
         let settings = UserDefaults.standard
         let sortField = settings.string(forKey: Constants.kSortField)
        
        var i = 0
        for field in sortOrderItems {
            if field == sortField {
                pickSortField.selectRow(i, inComponent: 0, animated: false)
            }
            i += 1
        }
        pickSortField.reloadComponent(0)
    }
    
    // MARK: UIPickerViewDelegate Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Chosen items: \(sortOrderItems[row])")
        
        let sortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(sortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
