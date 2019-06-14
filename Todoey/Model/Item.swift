//
//  Item.swift
//  Todoey
//
//  Created by Steve Berlin on 6/13/19.
//  Copyright © 2019 Steve Berlin. All rights reserved.
//

// data model class for todo items

class Item : Codable { // inheriting the Codable protocol makes the class encodable and decodable to .plist or JSON datatypes
    // Encodable, Decodable and Codable (which equles Endocable and Decodable) requires all properties use of standard data types,
    // ie; Int, String, Float, Bool, etc.  Custom classes can not be used as properties.
    var title : String = ""
    var done : Bool = false
}
