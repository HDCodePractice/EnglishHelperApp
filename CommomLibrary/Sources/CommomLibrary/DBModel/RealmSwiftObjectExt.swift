//
//  RealmSwiftObjectExt.swift
//  
//
//  Created by 老房东 on 2022-05-26.
//

import RealmSwift
import Realm
import OSLog

extension Object {
    func toDictionary() -> [String: Any] {
        let properties = self.objectSchema.properties.map { $0.name }
        var mutabledic = self.dictionaryWithValues(forKeys: properties)
        for prop in self.objectSchema.properties as [Property] {
            // find lists
            if let nestedObject = self[prop.name] as? Object {
                mutabledic[prop.name] = nestedObject.toDictionary()
            } else if let nestedListObject = self[prop.name] as? RLMSwiftCollectionBase {
                var objects = [[String: Any]]()
                for index in 0..<nestedListObject._rlmCollection.count  {
                    let object = nestedListObject._rlmCollection[index] as! Object
                    objects.append(object.toDictionary())
                }
                mutabledic[prop.name] = objects
            }
        }
        return mutabledic
    }
}
