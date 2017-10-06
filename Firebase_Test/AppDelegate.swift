//
//  AppDelegate.swift
//  Firebase_Test
//
//  Created by Warren Hansen on 9/25/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge ]) { (isGranted, err) in
            if err != nil {
                print("something bad happened in Notifiction auth")
            } else {
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                    let newToken = InstanceID.instanceID().token()
                    print("\nToken: \(newToken!)\n")
                }
         
            }
        }
        
        FirebaseApp.configure()
        
        return true
    }

    func connectToFCM() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
   
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFCM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        let newToken = InstanceID.instanceID().token()
        print("\nToken: \(String(describing: newToken))\n")
        connectToFCM()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.alert, .sound, .badge ])
        UIApplication.shared.applicationIconBadgeNumber += 1
    }
}

