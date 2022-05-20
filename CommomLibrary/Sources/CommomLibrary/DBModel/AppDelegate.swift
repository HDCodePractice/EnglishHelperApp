//
//  File.swift
//  
//
//  Created by 老房东 on 2022-05-19.
//

import UIKit
import IceCream
import CloudKit

public class AppDelegate: NSObject, UIApplicationDelegate {
    var syncEngine: SyncEngine?
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Enable CloudKit / IceCream Syncronization ----------------------
        syncEngine = SyncEngine(objects: [
            SyncObject(type: Word.self),
            SyncObject(type: Picture.self, uListElementType: Word.self),
            SyncObject(type: Topic.self, uListElementType: Picture.self),
            SyncObject(type: Chapter.self, uListElementType: Topic.self),
        ])
        application.registerForRemoteNotifications()
        // ----------------------------------------------------------------
        print("didFinishLaunchingWithOptions")
        return true
    }
    
    // Enable CloudKit / IceCream Syncronization
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let dict = userInfo as? [String: NSObject], let notification = CKNotification(fromRemoteNotificationDictionary: dict), let subscriptionID = notification.subscriptionID, IceCreamSubscription.allIDs.contains(subscriptionID) {
            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
            completionHandler(.newData)
        }
        print("didReceiveRemoteNotification")
    }
    
}
