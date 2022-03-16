//
//  File.swift
//  
//
//  Created by 老房东 on 2022-03-15.
//

import Foundation

public extension UserDefaults{
    enum  UserDefaultsKeys:String {
        case isAutoPronounce
    }
    
    func isAutoPronounce()->Bool{
        register(defaults: [UserDefaultsKeys.isAutoPronounce.rawValue : true])
        return bool(forKey: UserDefaultsKeys.isAutoPronounce.rawValue)
    }
    
    func setIsAutoPronounce(_ value: Bool){
        set(value, forKey: UserDefaultsKeys.isAutoPronounce.rawValue)
    }
}
