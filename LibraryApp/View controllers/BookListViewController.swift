//
//  BookListViewController.swift
//  LibraryApp
//
//  Created by SHILEI CUI on 4/2/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

extension BookListViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "bookCell")
        let book = bookList[indexPath.row]
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text = book.author
        return cell!
    }
    
    
}

class BookListViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var bookList = [Book]()
    var bookDept: BookDepartment!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //don't need fetch again from db.
        bookList = bookDept.books?.allObjects as! [Book]
        tblView.reloadData()
    }
    
}
