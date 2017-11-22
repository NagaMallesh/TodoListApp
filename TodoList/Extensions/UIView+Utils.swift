//
//  UIView+Utils.swift
//  TodoList
//
//  Created by Naga on 22/11/17.
//  Copyright © 2017 todo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyCorners() {
        layer.cornerRadius = 5
        self.layer.borderWidth = 1
        layer.borderColor = UIColor.init(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0).cgColor
    }
}
