//
//  RealmDatabaseManager.swift
//  TodoListBackendSDK
//
//  Created by Naga on 21/11/17.
//  Copyright © 2017 todo. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmDatabaseManager {
    private init() {
        do {
            realm = try Realm()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    private var realm: Realm?
    
    public static let shared = RealmDatabaseManager()
    
    public func addTodo(todoItem: TodoItem) {
        todoItem.id = randomString(title: todoItem.title)
        
        try? realm?.write {
            realm?.add(todoItem)
        }
    }
    
    public func deleteTodo(todoItem: TodoItem) {
        try? realm?.write {
            realm?.delete(todoItem)
        }
    }
    
    public func updateTodo(todoItem: TodoItem, updatedValues:[String: Any]) {
        try? realm?.write {
            todoItem.title = updatedValues["title"] as? String ?? ""
            todoItem.details = updatedValues["details"] as? String ?? ""
            todoItem.date = updatedValues["date"] as? Date ?? Date()
            todoItem.priority = updatedValues["priority"] as? Priority ?? .low
            
            realm?.add(todoItem, update: true)
        }
    }
    
    public func allTodos() -> [TodoItem] {
        var todoItems: [TodoItem] = []
        
        if let results = realm?.objects(TodoItem.self), results.count > 0 {
            for result in results {
                todoItems.append(result)
            }
        }
        
        return todoItems
    }
    
    public func allTodosSortByPriority() -> [TodoItem] {
        var todoItems: [TodoItem] = []
        
        if let results = realm?.objects(TodoItem.self).sorted(byKeyPath: "priority"), results.count > 0 {
            for result in results {
                todoItems.append(result)
            }
        }
        
        return todoItems
    }
    
    public func allTodosSortByDate() -> [TodoItem] {
        var todoItems: [TodoItem] = []
        
        if let results = realm?.objects(TodoItem.self).sorted(byKeyPath: "date"), results.count > 0 {
            for result in results {
                todoItems.append(result)
            }
        }
        
        return todoItems
    }
    
    public func searchByString(searchString: String) -> [TodoItem] {
        var todoItems: [TodoItem] = []
        
        let predicate = NSPredicate(format: "title CONTAINS[c] %@ OR details CONTAINS[c] %@", searchString, searchString)
        if let results = realm?.objects(TodoItem.self).filter(predicate), results.count > 0 {
            for result in results {
                todoItems.append(result)
            }
        }
        
        return todoItems
    }
    
    private func randomString(title: String) -> String {
        return "\(title) - \(arc4random())"
    }
}
