//
//  IrregularVerb.swift
//  
//
//  Created by 老房东 on 2022-05-30.
//

import Foundation
import RealmSwift

public class IrregularVerb: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) public var baseForm: String
    @Persisted public var simplePast = RealmSwift.List<String>()
    @Persisted public var pastParticiple = RealmSwift.List<String>()
}

