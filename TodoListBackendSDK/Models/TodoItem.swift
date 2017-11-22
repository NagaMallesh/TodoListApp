//
//  TodoItem.swift
//  TodoListBackendSDK
//
//  Created by Naga on 21/11/17.
//  Copyright © 2017 todo. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

@objc public enum Priority: Int {
    case low = 0
    case medium = 1
    case high = 2
}

public class TodoItem: Object {
    
    @objc public dynamic var id: String = ""
    @objc public dynamic var title: String = ""
    @objc public dynamic var details: String = ""
    @objc public dynamic var date: Date = Date()
    @objc public dynamic var priority: Priority = .low
    
    public init(todoTitle: String, todoDetails: String, todoPriority: Priority, todoDate: Date) {
        super.init()
        
        title = todoTitle
        details = todoDetails
        date = todoDate
        priority = todoPriority
    }
    
    required public init() {
        super.init()
    }
    
    required public init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required public init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
}
