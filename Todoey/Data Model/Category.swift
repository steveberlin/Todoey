//
//  Category.swift
//  Todoey
//
//  Created by Steve Berlin on 6/16/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    // List is a Realm object similar to an array.  The line below defines the one-to-many forward relationship of an array (List)
    // of Item objects of <Item> objects that are empty ().
    // This uses the same valid swift Array initizlization syntax, different versions shown below.
    let items = List<Item>()
}
// Different ways to initizlize an Array in Swift
// let array = [1,2,3] uses type inference
// let array : [Int]() empty array of integers
// let array : [Int] = [1,2,3]
// let array : Array<Int> = [1,2,3] (same as above)
// let array : Array<Int>() empty array of integers
