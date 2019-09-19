//
//  Data.swift
//  Todoey
//
//  Created by Deep Patel on 9/18/19.
//  Copyright © 2019 Deep Patel. All rights reserved.
//

import Foundation
import RealmSwift


//subclass Object since it defines realm model objects
class Data: Object {
//needs both keywords @objc and dynamic to work with realm - since it uses dynamic variables and those come from objective C
@objc dynamic var name: String = ""
@objc dynamic var age: Int = 13

}
