//
//  AppDelegate.swift
//  ImageViever
//
//  Created by Denis Medvedev on 25/10/2021.
//  Copyright © 2021 Denis Medvedev. All rights reserved.
//

import UIKit
import Nuke

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NetworkMonitor.shared.startMonitoring()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        NetworkMonitor.shared.stopMonitoring()
        ImageCache.shared.removeAll()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        NetworkMonitor.shared.startMonitoring()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    //ориентация экрана
    /// set orientations you want to be allowed in this property by default
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        //разблокируем все ориентации после того, как пропал launchScreen
        //внимание, если возникнут проблемы с ориентациями бежим сюда
        //https://stackoverflow.com/questions/47884449/splash-screen-orientation-lock
        //стоковый код:
        //return self.orientationLock
        let orientations = UIInterfaceOrientationMask.all
        return orientations
    }


}

