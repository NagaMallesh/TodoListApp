//
//  TodoItemCell.swift
//  TodoList
//
//  Created by Naga on 22/11/17.
//  Copyright © 2017 todo. All rights reserved.
//

import Foundation
import UIKit
import TodoListBackendSDK

class TodoItemCell: MGSwipeTableCell {
    @IBOutlet weak var priority: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var todoDescription: UILabel!
    
    let priorities:[String] = ["Low", "Medium", "High"]
    
    func setUp(todoItem: TodoItem) {
        title.text = todoItem.title
        todoDescription.text = todoItem.details
        date.text = todoItem.date.stringFromDate()
        priority.text = priorities[todoItem.priority.rawValue]
    }
}
