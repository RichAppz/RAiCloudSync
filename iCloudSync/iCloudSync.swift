//
//  iCloudSync.swift
//  RichAppz
//
//  Created by Rich Abery on 10/07/2016.
//  Copyright © 2016 RichAppz Limited. All rights reserved.
//  richappz.com
//

import UIKit

public let raCloudSyncNotification: String = "raCloudSyncNotificaion"

class iCloudSyncListenr {
    
    //================================================================================
    // MARK: Variables
    //================================================================================
    
    var prefix: String = ""
    
    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    static let manager = iCloudSyncListenr()
    private init() {}
    
    //================================================================================
    // MARK: Start Service
    //================================================================================
    
    /// Start the iCloudSync with the prefix that you would like to listen for
    /// :params: prefix: String value of the key required
    static func startWithPrefix(prefix: String) {
        manager.prefix = prefix
        
        // Set up notifiers for iCloudSync
        setListenerFromCloud()
        setListenerForNotificationChange()
        NSNotificationCenter.defaultCenter().postNotificationName(raCloudSyncNotification, object: nil)
        
        let cloudStorage = NSUbiquitousKeyValueStore.defaultStore()
        let dict = cloudStorage.dictionaryRepresentation
        for (key, value) in dict {
            if key.hasPrefix(manager.prefix) {
                NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
            }
        }
    }
    
    //================================================================================
    // MARK: Helpers
    //================================================================================
    
    @objc private static func updateToiCloud(notification: NSNotification) {
        let dict = NSUserDefaults.standardUserDefaults().dictionaryRepresentation()
        
        for (key, value) in dict {
            if key.hasPrefix(manager.prefix) {
                NSUbiquitousKeyValueStore.defaultStore().setObject(value, forKey: key)
            }
            NSUbiquitousKeyValueStore.defaultStore().synchronize()
        }
    }
    
    @objc private static func updateFromiCloud(notification: NSNotification) {
        let cloudStorage = NSUbiquitousKeyValueStore.defaultStore()
        let dict = cloudStorage.dictionaryRepresentation
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
        for (key, value) in dict {
            if key.hasPrefix(manager.prefix) {
                NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
            }
        }
        setListenerForNotificationChange()
    }
    
    private static func setListenerFromCloud() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(iCloudSyncListenr.updateFromiCloud(_:)),
            name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification,
            object: nil)
    }
    
    private static func setListenerForNotificationChange() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(iCloudSyncListenr.updateToiCloud(_:)),
            name: NSUserDefaultsDidChangeNotification,
            object: nil)
    }
    
    //================================================================================
    // MARK: Deinit
    //================================================================================
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSUserDefaultsDidChangeNotification, object: nil)
    }
}
