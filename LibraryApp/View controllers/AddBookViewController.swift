//
//  AddBookViewController.swift
//  LibraryApp
//
//  Created by SHILEI CUI on 4/2/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController {

    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var deptIdField: UITextField!
    @IBOutlet weak var digitField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func saveBtnClick(_ sender: UIButton) {
        if let name = nameField.text, !name.isEmpty, let id = deptIdField.text, !id.isEmpty,let author = authorField.text, !author.isEmpty, let pages = digitField.text, !pages.isEmpty, let publisher = publisherField.text, !publisher.isEmpty{
            DatabaseManager.shared.addBook(author: author, name: name, pages: Int32(pages)!, publisher: publisher, deptid: Int32(id)!)
        }
    }
    
}
