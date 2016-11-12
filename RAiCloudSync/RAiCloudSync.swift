//
//  RAiCloudSync.swift
//  RichAppz
//
//  Copyright © 2016 RichAppz Limited. All rights reserved.
//  richappz.com - (rich@richappz.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

public let RAiCloudSyncNotification = Notification.Name(rawValue: "com.richappz.cloudsync.notification")

class RAiCloudSync {
    
    //================================================================================
    // MARK: Variables
    //================================================================================
    
    var keys        = [String]()
    var isSyncing   = false

    //================================================================================
    // MARK: Singleton
    //================================================================================
    
    static let manager = RAiCloudSync()
    private init() {}

    //================================================================================
    // MARK: Start Functions
    //================================================================================
    
    /// Start the iCloudSync with the prefix that you would like to listen for
    /// :params: keys: [String] value of the keys required
    internal static func start(withKeys keys: [String]) {
        manager.keys        = keys
        manager.isSyncing   = true
        
        // Set up notifiers for iCloudSync
        setListenerFromCloud()
        setListenerForNotificationChange()
        
        let cloudStorage = NSUbiquitousKeyValueStore.default()
        let dict = cloudStorage.dictionaryRepresentation
        for (key, value) in dict {
            if manager.keys.contains(key) {
                UserDefaults.standard.set(value, forKey: key)
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RAiCloudSyncNotification), object: nil)
        }
    }
    
    /// Remove a key stored in the manager
    /// :params: key: String value of the key to be removed
    internal static func remove(key: String) {
        manager.keys.removeObject(object: key)
        if manager.keys.count == 0 { removeAllObservers() }
    }
    
    /// Listen for a new key
    /// :params: key: String value of the key to be added
    internal static func add(key: String) {
        manager.keys.append(key)
        if !manager.isSyncing {
            setListenerFromCloud()
            setListenerForNotificationChange()
        }
    }
    
    /// Stops and resets the service
    internal static func stop() {
        manager.keys        = []
        manager.isSyncing   = false
        removeAllObservers()
    }

    //================================================================================
    // MARK: Private Helpers
    //================================================================================
    
    private static func setListenerFromCloud() {
        NotificationCenter.default.addObserver(
            forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
            object: nil,
            queue: nil,
            using: { notification in
                let cloudStorage = NSUbiquitousKeyValueStore.default()
                let dict = cloudStorage.dictionaryRepresentation

                NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
                for (key, value) in dict {
                    if manager.keys.contains(key) {
                        UserDefaults.standard.set(value, forKey: key)
                    }
                }

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: RAiCloudSyncNotification), object: nil)
                setListenerForNotificationChange()
        })
    }
    
    private static func setListenerForNotificationChange() {
        NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil, using: { notification in
            let dict = UserDefaults.standard.dictionaryRepresentation()

            for (key, value) in dict {
                if manager.keys.contains(key) {
                    NSUbiquitousKeyValueStore.default().set(value, forKey: key)
                }
                NSUbiquitousKeyValueStore.default().synchronize()
            }
        })
    }
    
    //================================================================================
    // MARK: Deinit
    //================================================================================
    
    private static func removeAllObservers() {
        manager.isSyncing = false
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UserDefaults.didChangeNotification, object: nil)
    }
    
}
