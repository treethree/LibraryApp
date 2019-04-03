//
//  AddBookDeptViewController.swift
//  LibraryApp
//
//  Created by SHILEI CUI on 4/2/19.
//  Copyright © 2019 scui5. All rights reserved.
//

import UIKit

class AddBookDeptViewController: UIViewController {

    @IBOutlet weak var deptID: UITextField!
    @IBOutlet weak var deptNameField: UITextField!
    @IBOutlet weak var deptLocationField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func saveBtnClick(_ sender: UIButton) {
        if let name = deptNameField.text, !name.isEmpty, let id = deptID.text, !id.isEmpty,let location = deptLocationField.text, !location.isEmpty{
            DatabaseManager.shared.addBookDept(name: name, id: Int32(id)!, location: location)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
