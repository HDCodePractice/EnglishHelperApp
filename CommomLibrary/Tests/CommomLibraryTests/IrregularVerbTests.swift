//
//  IrregularVerbTests.swift
//  
//
//  Created by 老房东 on 2022-05-30.
//

import XCTest
import RealmSwift
@testable import CommomLibrary

class IrregularVerbTests: XCTestCase {
    
    var realmController : RealmController  = RealmController()
    
    override func setUpWithError() throws {
        realmController = RealmController()
        realmController.localRealm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "test"))
    }

    override func tearDownWithError() throws {
        realmController.cleanRealm()
    }

    func test_whenCreateRealmObjectSearchAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        try! localRealm.write{
            let irregularVerb = IrregularVerb(value: [
                "baseForm":"baseForm",
                "simplePast":["simplePast1","simplePast2","simplePast3"],
                "pastParticiple": ["pastParticiple"]
            ])
            localRealm.add(irregularVerb)
        }
        let irregularVerbs = localRealm.objects(IrregularVerb.self)
        XCTAssertEqual(irregularVerbs.count, 1)
        XCTAssertEqual(1, irregularVerbs.where({ $0.pastParticiple.contains("pastParticiple")}).count)
        XCTAssertEqual(1, irregularVerbs.where({ $0.simplePast.contains("simplePast1")}).count)
        XCTAssertEqual(1, irregularVerbs.filter({ $0.pastParticiple.contains(where: { $0.contains("past")})}).count)
        XCTAssertEqual(1, irregularVerbs.filter{ $0.simplePast.contains(where: { $0.contains("3")})}.count)
    }

    func test_whenFromJsonCreateOneRealmObjectAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        let data = """
    {
        "baseForm":"baseForm1",
        "simplePast":["simplePast11","simplePast12","simplePast13"],
        "pastParticiple": ["pastParticiple1"]
    }
""".data(using: .utf8)!
        let data2 = """
    {
        "baseForm":"baseForm2",
        "simplePast":["simplePast21","simplePast22","simplePast23"],
        "pastParticiple": ["pastParticiple2"]
    }
""".data(using: .utf8)!
        
        try! localRealm.write{
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            localRealm.create(IrregularVerb.self, value: json, update: .modified)
            let irregularVerbs = localRealm.objects(IrregularVerb.self)
            XCTAssertEqual(irregularVerbs.count, 1)
            let json2 = try! JSONSerialization.jsonObject(with: data2, options: [])
            localRealm.create(IrregularVerb.self, value: json2, update: .modified)
            XCTAssertEqual(irregularVerbs.count, 2)
        }
    }
    
    func test_whenFromJsonCreateRealmObjectsAboutCount() throws{
        guard let localRealm = realmController.localRealm else { return }
        
        let data = """
        [
            {
                "baseForm":"baseForm1",
                "simplePast":["simplePast11","simplePast12","simplePast13"],
                "pastParticiple": ["pastParticiple1"]
            },
            {
                "baseForm":"baseForm2",
                "simplePast":["simplePast21","simplePast22","simplePast23"],
                "pastParticiple": ["pastParticiple2"]
            },
            {
                "baseForm":"baseForm3",
                "simplePast":["simplePast21","simplePast22","simplePast23"],
                "pastParticiple": ["pastParticiple2"]
            },
            {
                "baseForm":"baseForm4",
                "simplePast":["simplePast21","simplePast22","simplePast23"],
                "pastParticiple": ["pastParticiple2"]
            }
        ]
        """.data(using: .utf8)!
        
        try! localRealm.write{
            if let jsons = try! JSONSerialization.jsonObject(with: data, options: []) as? [Any]{
                for i in 0..<jsons.count {
                    localRealm.create(IrregularVerb.self, value: jsons[i], update: .modified)
                    let irregularVerbs = localRealm.objects(IrregularVerb.self)
                    print(irregularVerbs.count)
                    XCTAssertEqual(irregularVerbs.count, i+1)
                }
            }
            let irregularVerbs = localRealm.objects(IrregularVerb.self)
            XCTAssertEqual(4, irregularVerbs.filter{ $0.simplePast.contains(where: { $0.contains("simplePast")})}.count)
            XCTAssertEqual(1, irregularVerbs.filter{ $0.simplePast.contains(where: { $0.contains("11")})}.count)
            XCTAssertEqual(1, irregularVerbs.filter{ $0.simplePast.contains(where: { $0.contains("12")})}.count)
        }
    }
}
