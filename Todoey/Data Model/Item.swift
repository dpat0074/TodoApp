//
//  Item.swift
//  Todoey
//
//  Created by Deep Patel on 9/12/19.
//  Copyright © 2019 Deep Patel. All rights reserved.
//

import Foundation

//using encodable to allow for use in custom pList user defaults
//encodable will not work with new pList if class within class only primitive type properties
//Codeable = Encodable, Decodable together
class Item : Codable {
    
    var title : String = ""
    var done : Bool = false
}
