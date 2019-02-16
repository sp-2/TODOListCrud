//
//  AddItemViewControllerDelegate.swift
//  todoList
//
//  Created by SP on 3/17/18.
//  Copyright © 2018 Soumya. All rights reserved.
//

import Foundation

protocol AddItemViewControllerDelegate: class{
    //func itemSaved(by controller: AddItemViewController, with data:[String : String])
    func itemSaved(by controller: AddItemViewController, with data:[String : String], with_date with_date: Date, at indexPath: IndexPath?)
    //func itemSaved(by controller: AddItemViewController, with data:TodoListItem, at indexPath: IndexPath?)
}
