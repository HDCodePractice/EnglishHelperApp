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
    @Persisted public var simplePast : String = ""
    @Persisted public var pastParticiple : String = ""
}

