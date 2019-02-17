//
//  TableViewController.swift
//  todoList
//
//  Created by SP on 3/17/18.
//  Copyright © 2018 Soumya. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, AddItemViewControllerDelegate {

    var items = [TodoListItem]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate          = (UIApplication.shared.delegate) as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func fetchAllItems(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoListItem")
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [TodoListItem]
        } catch {
            print("\(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomCell
        
        cell.titleLabel.text = String(describing: items[indexPath.row].title!)
        cell.notesLabel.text = String(describing: items[indexPath.row].notes!)
        cell.dateLabel.text  = String(describing: items[indexPath.row].date!)
        
        if let cm = items[indexPath.row].completed  {
            if(cm == "true"){
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                items[indexPath.row].completed = "false"
            }
            else{
                cell.accessoryType = .checkmark
                items[indexPath.row].completed = "true"
            }
        }
        
        do{
            try managedObjectContext.save()
        } catch{
            print("\(error)")
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "addSegue"){
            
            let navigationController = segue.destination as! UINavigationController
            let addItemViewController = navigationController.topViewController as! AddItemViewController
            addItemViewController.delegate = self
            
            if let indexPath = sender as? IndexPath {
                let item = items[indexPath.row]
                addItemViewController.item = item
                addItemViewController.indexPath = indexPath
            }
        }
    }

    func itemSaved(by controller: AddItemViewController, with data: [String : String], with_date data_date: Date, at indexPath: IndexPath?){
        
        if let ip = indexPath {
            items[ip.row].title = data["title"]!
            items[ip.row].notes = data["notes"]!
            items[ip.row].date  = data_date
            items[ip.row].completed = data["completed"]!
            appDelegate.saveContext()
        }
        else {
            let item = NSEntityDescription.insertNewObject(forEntityName: "TodoListItem", into: managedObjectContext) as! TodoListItem
            item.title = data["title"]!
            item.notes = data["notes"]!
            item.date  = data_date
            item.completed = data["completed"]!
            
            items.append(item)
            
            do{
                try managedObjectContext.save()
            } catch{
                print("\(error)")
            }

        }
        
        tableView.reloadData()
        dismiss(animated: true, completion: nil)

    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            managedContext.delete(self.items[indexPath.row])
            
            self.items.remove(at: indexPath.row)
            
            do{
                try self.managedObjectContext.save()
            } catch{
                print("\(error)")
            }
            tableView.reloadData()
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            self.performSegue(withIdentifier: "addSegue", sender: indexPath)
        }
        
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
}

