//
//  AddItemViewController.swift
//  todoList
//
//  Created by SP on 3/17/18.
//  Copyright © 2018 Soumya. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var notesText: UITextField!
    
    @IBOutlet weak var dateField: UIDatePicker!
    
    var item:TodoListItem?
    
    var indexPath: IndexPath?

    weak var delegate: AddItemViewControllerDelegate?
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let tText = titleLabel.text!
        let nText = notesText.text!
        let dateF = dateField.date

        let data = ["title":tText,"notes":nText,"completed":"false"] as [String : String]
        let data_date = dateF

        delegate?.itemSaved(by: self, with: data, with_date: data_date, at: indexPath)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = item?.title
        notesText.text  = item?.notes
        dateField.date  = item?.date ?? Date()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
