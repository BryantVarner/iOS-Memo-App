//
//  MemoTableViewController.swift
//  MyMemo
//
//  Created by Cistudent on 11/26/19.
//  Copyright © 2019 Cistudent. All rights reserved.
//

import UIKit
import CoreData

class MemoTableViewController: UITableViewController {
    
    var memos:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadDataFromDatabase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadDataFromDatabase()
        tableView.reloadData()
    }
    
    func loadDataFromDatabase() {
        let settings = UserDefaults.standard
        var sortField = settings.string(forKey: Constants.kSortField)
        
        // sorting function!!!!!!!!!!!!!!!!!
        
        var priority = true
        if sortField == "high" {
            sortField = "prio"
            priority = true
        }
        if sortField == "low" {
            sortField = "prio"
            priority = false
        }
    
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Memo")
        let sortDescriptor = NSSortDescriptor(key: sortField, ascending: priority)
        let sortDescriptorArray = [sortDescriptor]
        request.sortDescriptors = sortDescriptorArray
        do {
            memos = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath)
        let memo = memos[indexPath.row] as? Memo
        cell.textLabel?.text = memo?.memoTitle
      
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        if memo?.memo_date != nil {
            cell.detailTextLabel?.text = formatter.string(from: memo!.memo_date as! Date)
        }
        else {
            cell.detailTextLabel?.text = "Date: "
        }
 
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditMemo" {
            let memoController = segue.destination as? MemoViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedMemo = memos[selectedRow!] as? Memo
            memoController?.currentMemo = selectedMemo!
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let memo = memos[indexPath.row] as? Memo
            let context = appDelegate.persistentContainer.viewContext
            context.delete(memo!)
            do {
                try context.save()
            }
            catch {
                fatalError("Error saving context: \(error)")
            }
            
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
