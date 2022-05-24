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
        
        let _ = RealmController.shared
        
        // Enable CloudKit / IceCream Syncronization ----------------------
        syncEngine = SyncEngine(objects: [
            //            SyncObject(type: Chapter.self, uListElementType: Topic.self),
            SyncObject(type: ChapterSelect.self)
        ])
        // try 
        if let syncEngine = syncEngine {
            syncEngine.pull(completionHandler: { error in
                let defaults = UserDefaults.standard
                defaults.setIsCloudSynced(true)
            })
        }
        
        application.registerForRemoteNotifications()
        // ----------------------------------------------------------------
        return true
    }
    
    // Enable CloudKit / IceCream Syncronization
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let dict = userInfo as? [String: NSObject], let notification = CKNotification(fromRemoteNotificationDictionary: dict), let subscriptionID = notification.subscriptionID, IceCreamSubscription.allIDs.contains(subscriptionID) {
            NotificationCenter.default.post(name: Notifications.cloudKitDataDidChangeRemotely.name, object: nil, userInfo: userInfo)
            completionHandler(.newData)
        }
    }
    
}
