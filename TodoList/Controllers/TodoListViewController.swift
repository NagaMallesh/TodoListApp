//
//  TodoListViewController.swift
//  TodoList
//
//  Created by Naga on 21/11/17.
//  Copyright © 2017 todo. All rights reserved.
//

import Foundation
import UIKit
import TodoListBackendSDK

class TodoListViewController: UITableViewController {

    var todoItems: [TodoItem] = []
    var filteredTodoItems: [TodoItem] = []
    var searchController : UISearchController!
    
    // MARK:- UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoItems = RealmDatabaseManager.shared.allTodos()
        
        tableView.estimatedRowHeight = 250
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.searchController = UISearchController.init(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = true
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.tintColor = UIColor.darkGray
        
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        self.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = [.top,.bottom]
    }
    
    // MARK:- Actions
    
    @IBAction func addTodoItem() {
        if let todoCreateNavVC = storyboard?.instantiateViewController(withIdentifier: "TodoCreateNavVC") as? UINavigationController,
            let todoCreateVC = todoCreateNavVC.topViewController as? TodoCreateViewController {
            
            todoCreateVC.delegate = self
            present(todoCreateNavVC, animated: true, completion: {})
        }
    }
    
    @IBAction func showSortOptions() {
        let sortByDateAction = UIAlertAction.init(title: "Date", style: .default, handler: { action in
            self.todoItems = RealmDatabaseManager.shared.allTodosSortByDate()
            self.tableView.reloadData()
        })
        
        let sortByPriorityAction = UIAlertAction.init(title: "Priority", style: .default, handler: { action in
            self.todoItems = RealmDatabaseManager.shared.allTodosSortByPriority()
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
        let sortActionSheet = UIAlertController.init(title: "Sorty By", message: "", preferredStyle: .actionSheet)
        sortActionSheet.addAction(sortByDateAction)
        sortActionSheet.addAction(sortByPriorityAction)
        sortActionSheet.addAction(cancelAction)
        
        present(sortActionSheet, animated: true, completion: {})
    }
    
    // MARK:- UITableViewDatasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = todoItems.count
        
        if let _ = searchController.searchBar.text, searchController.isActive {
            count = filteredTodoItems.count
        }
        
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath) as! TodoItemCell
        
        var todoItem = todoItems[indexPath.row]

        if let _ = searchController.searchBar.text, searchController.isActive {
            todoItem = filteredTodoItems[indexPath.row]
        }
        
        cell.setUp(todoItem: todoItem)
        cell.delegate = self
        
        return cell
    }
}

// MARK: Cell Swipe Delegates

extension TodoListViewController: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        if direction == .leftToRight {
            return false
        }
        
        return true
    }
    
    @objc func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsForDirection direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [AnyObject]! {
        
        if direction == .rightToLeft {
            // The Delete Cell Button
            let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.red) { (cell : MGSwipeTableCell!) -> Bool in
                
                if let indexPath = self.tableView.indexPath(for: cell) {
                    RealmDatabaseManager.shared.deleteTodo(todoItem: self.todoItems[indexPath.row])
                    self.todoItems = RealmDatabaseManager.shared.allTodos()
                    self.tableView.reloadData()
                }
                
                return true
            }
            
            // The Clear Cell Button
            let updateButton = MGSwipeButton(title: "Update", backgroundColor: UIColor.darkGray) { (cell : MGSwipeTableCell!) -> Bool in
                
                if let todoCreateNavVC = self.storyboard?.instantiateViewController(withIdentifier: "TodoCreateNavVC") as? UINavigationController,
                    let todoCreateVC = todoCreateNavVC.topViewController as? TodoCreateViewController,
                    let indexPath = self.tableView.indexPath(for: cell) {
                    
                    todoCreateVC.todoItem = self.todoItems[indexPath.row]
                    todoCreateVC.operationType = .update
                    todoCreateVC.delegate = self
                    
                    self.present(todoCreateNavVC, animated: true, completion: {})
                }
                
                return true
            }
            
            return [deleteButton, updateButton]
        }
        
        return nil
    }
}

// MARK: UI Update Delegate

extension TodoListViewController: CreateAndUpdateDelegate {
    func updateTableView() {
        todoItems = RealmDatabaseManager.shared.allTodos()
        tableView.reloadData()
    }
}

// MARK: UISearch Delegates

extension TodoListViewController: UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text {
            filteredTodoItems = RealmDatabaseManager.shared.searchByString(searchString: searchString)
            tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}
