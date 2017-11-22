//
//  TodoCreateViewController.swift
//  TodoList
//
//  Created by Naga on 21/11/17.
//  Copyright © 2017 todo. All rights reserved.
//

import Foundation
import UIKit
import TodoListBackendSDK

enum ToDoOperationType: Int {
    case add
    case update
}

protocol CreateAndUpdateDelegate: class {
    func updateTableView()
}

class TodoCreateViewController: UIViewController {
    @IBOutlet weak var textTitle: UITextField!
    @IBOutlet weak var textDate: UITextField!
    @IBOutlet weak var textPriority: UITextField!
    @IBOutlet weak var tvDetails: UITextView!
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    
    var operationType: ToDoOperationType = .add
    var todoItem: TodoItem?
    weak var delegate: CreateAndUpdateDelegate?
    
    var todoItemDate: Date = Date()
    var todoItemPriority: Priority = .low
    let priorities:[String] = ["Low", "Medium", "High"]
    
    // MARK:- UIViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvDetails.applyCorners()
        
        if operationType == .update {
            setUpUpdateUI()
        }
    }
    
    // MARK:- Methods
    
    func setUpUpdateUI() {
        todoItemPriority = todoItem?.priority ?? .low
        todoItemDate = todoItem?.date ?? Date()
        
        actionButton.title = "Update"
        title = "Update Todo Item"
        
        textTitle.text = todoItem?.title
        tvDetails.text = todoItem?.details
        textDate.text = todoItemDate.stringFromDate()
        textPriority.text = priorities[todoItemPriority.rawValue]
    }
    
    // MARK:- Actions
    
    @IBAction func save() {
        
        guard let title = textTitle.text, let details = tvDetails.text else {
            return
        }
        
        if operationType == .add {
            RealmDatabaseManager.shared.addTodo(todoItem: TodoItem.init(todoTitle: title, todoDetails: details, todoPriority: todoItemPriority, todoDate: todoItemDate))
        } else {
            if let todoItem = todoItem {
                let todoItemDict: [String: Any] = ["title": title, "details": details, "date": todoItemDate, "priority": todoItemPriority]
                
                RealmDatabaseManager.shared.updateTodo(todoItem: todoItem, updatedValues: todoItemDict)
            }
        }
        
        delegate?.updateTableView()
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: {})
    }
    
    @IBAction func dateFieldEditing(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(TodoCreateViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @IBAction func priorityFieldEditing(sender: UITextField) {
        let prioritiesPicker = PickerViewController.init(data: priorities, selectedIndex: todoItem?.priority.rawValue ?? 0)
        prioritiesPicker?.showPicker(from: self, doneHandler: {
            selectedPriorityIndex in
            
            self.todoItemPriority = Priority.init(rawValue: selectedPriorityIndex)!
            self.textPriority.text = self.priorities[self.todoItemPriority.rawValue]
        })
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        textDate.text = sender.date.stringFromDate()
        todoItemDate = sender.date
    }
}
