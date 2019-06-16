//
//  Item.swift
//  Todoey
//
//  Created by Steve Berlin on 6/16/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    // Linking Objects create inverse relationships.
    // fromType: Catagory by itself is just the class
    // fromType: Category.self specifies the type
    // what is the property name that specifies the forward relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
