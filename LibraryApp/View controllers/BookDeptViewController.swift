//
//  BookDeptViewController.swift
//  LibraryApp
//
//  Created by SHILEI CUI on 4/2/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

extension BookDeptViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return depts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "Cell")
        let dept = depts[indexPath.row]
        cell?.textLabel!.text = dept.depName
        cell?.detailTextLabel!.text = String(dept.depId)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DatabaseManager.shared.deleteBookDept(bookDept: depts[indexPath.row])
            tblView.reloadData()
        default:
            print("error")
        }
    }
}

class BookDeptViewController: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    var depts = [BookDepartment]() // empty array.
    
    //viewdidload only call once
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Book Library"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        depts = DatabaseManager.shared.fetchBookDepts()
        tblView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookList"{
            let bookListVc = segue.destination as! BookListViewController
            let selectedDeptRow = tblView.indexPathForSelectedRow?.row
            let deptObj = depts[selectedDeptRow!]
            //relationship will hold all book data cause its one-to-many
            //bookListVc.bookList = deptObj.books?.allObjects as! [Book]
            
            bookListVc.bookDept = deptObj
            
            print(bookListVc.bookList)
        }
    }

}
