//
//  PrioViewController.swift
//  MyMemo
//
//  Created by Cistudent on 11/26/19.
//  Copyright © 2019 Cistudent. All rights reserved.
//

import UIKit
import CoreData

protocol DateControllerDelegate: class {
    func dateChanged(date: Date)
}

class PrioViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    weak var delegate: DateControllerDelegate?
    @IBOutlet weak var pickSortField2: UIPickerView!
    @IBOutlet weak var dtpDate: UIDatePicker!
    let sortOrderItems: Array<String> = ["low", "high"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(saveDate))
        self.navigationItem.rightBarButtonItem = saveButton
        self.title = "Pick Date"
    }
    
    func saveDate() {
        self.delegate?.dateChanged(date: dtpDate.date)
        self.navigationController?.popViewController(animated: true)
    }
   
    // MARK: UIPickerViewDelegate Methods
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
