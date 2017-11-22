//
//  NSDate+Utils.swift
//  TodoList
//
//  Created by Sreeman Penugonda on 22/11/17.
//  Copyright © 2017 todo. All rights reserved.
//

import Foundation

extension Date {
    func stringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        return dateFormatter.string(from: self)
    }
}
