//
//  Data.swift
//  Todoey
//
//  Created by Steve Berlin on 6/16/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

import Foundation
import RealmSwift

// Object is a class used to define Realm model objects

// dynamic is a declaration modifier.  it tells the run time to use dynamic dispatch
// instead of the standard static dispatch.  This allows the property to be monitored at runtime
// while the app is running.  Realm requires this because Realm needs to monitor for changes
// in the value of Realm properties.

// because dynamic dispatch comes from the objective c APIs you must include @objc also
class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
