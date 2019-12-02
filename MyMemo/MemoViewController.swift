//
//  MemoViewController.swift
//  MyMemo
//
//  Created by Cistudent on 11/25/19.
//  Copyright © 2019 Cistudent. All rights reserved.
//

import UIKit
import CoreData

class MemoViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UITextViewDelegate {
    
    var currentMemo: Memo?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var prioButton: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrio: UILabel!
    @IBOutlet weak var memoTitle: UITextField!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var memoText: UITextView!
    @IBOutlet weak var prioHigh: UIButton!
    @IBOutlet weak var prioLow: UIButton!
    
    @IBAction func btnPrioHigh(_ sender: Any) {
        lblPrio.text = "High"
        prioHigh.isEnabled = false
        prioLow.isEnabled = true
    }
    @IBAction func btnPrioLow(_ sender: Any) {
        lblPrio.text = "Low"
        prioLow.isEnabled = false
        prioHigh.isEnabled = true
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        
        let textFields: [UITextField] = [memoTitle]
        let textViews: [UITextView] = [memoText]
        
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textView in textViews {
                textView.isEditable = false
            }
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextBorderStyle.none
            }
            prioButton.isHidden = true
            prioHigh.isHidden = true
            prioLow.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textView in textViews {
                textView.isEditable = true
            }
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextBorderStyle.roundedRect
            }
            prioButton.isHidden = false
            prioHigh.isHidden = false
            prioLow.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveMemo))
        }
    }
   
    func dateChanged(date: Date) {
        // does this save date without having to click save twice?
        
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
        if currentMemo != nil {
            currentMemo?.memo_date = date as NSDate?
        }
            print(currentMemo?.memo_date)
            appDelegate.saveContext()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            lblDate.text = formatter.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueMemoPrio") {
            let dateController = segue.destination as! PrioViewController
            dateController.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeEditMode(self)
        
        let textFields: [UITextField] = [memoTitle]
        self.memoText.delegate = self
        
        if currentMemo == nil {
        memoText.text = "Memo Text:"
        memoText.textColor = UIColor.lightGray
        }
 
        for textfield in textFields {
            textfield.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                for: UIControlEvents.editingDidEnd)
        }
        
        // does memo work memo text view not updating if already in database CHECK IT
        if currentMemo != nil {
            memoTitle.text = currentMemo!.memoTitle
            lblPrio.text = currentMemo!.prio
            memoText.text = currentMemo!.memoText
            print(currentMemo!.memoText)
            if currentMemo?.memoText == nil {
                memoText.text = "Memo Text:"
                memoText.textColor = UIColor.lightGray
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            if currentMemo!.memo_date != nil {
                lblDate.text = formatter.string(from: currentMemo!.memo_date as! Date)
            }        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if memoText.textColor == UIColor.lightGray {
            memoText.text = nil
            memoText.textColor = UIColor.black
        }
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if memoText.text.isEmpty {
            memoText.text = "Memo Text:"
            memoText.textColor = UIColor.lightGray
        }
        else {
        currentMemo?.memoText = memoText.text
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentMemo?.memoTitle = memoTitle.text
        return true
    }
    //chnaged to save without having to go to set prio screen.. seems decent
    func saveMemo() {
        if currentMemo == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentMemo = Memo(context: context)
        }
        
        if memoText.text != "Memo Text:" && memoText.textColor != UIColor.lightGray {
            currentMemo?.memoText = memoText.text
        }
 
       // currentMemo?.memoText = memoText.text
        currentMemo?.memoTitle = memoTitle.text
        if lblPrio.text == "Priority:" {
            currentMemo?.prio = "Low"
        }
        else {
        currentMemo?.prio = lblPrio.text
        }
        print(currentMemo?.prio)
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
