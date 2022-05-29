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
        case isCloudSynced
    }
    
    func isAutoPronounce()->Bool{
        register(defaults: [UserDefaultsKeys.isAutoPronounce.rawValue : true])
        return bool(forKey: UserDefaultsKeys.isAutoPronounce.rawValue)
    }
    
    func setIsAutoPronounce(_ value: Bool){
        set(value, forKey: UserDefaultsKeys.isAutoPronounce.rawValue)
    }
    
    func isCloudSynced()->Bool{
        register(defaults: [UserDefaultsKeys.isCloudSynced.rawValue : false])
        return bool(forKey: UserDefaultsKeys.isCloudSynced.rawValue)
    }
    
    func setIsCloudSynced(_ value: Bool){
        set(value, forKey: UserDefaultsKeys.isCloudSynced.rawValue)
    }
}
