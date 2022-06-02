//
//  IrregularNoun.swift
//  
//
//  Created by 老房东 on 2022-06-02.
//

import RealmSwift

public class IrregularNoun: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var singular: String
    @Persisted public var plural: String = ""
}
