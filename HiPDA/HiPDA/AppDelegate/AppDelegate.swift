//
//  AppDelegate.swift
//  HiPDA
//
//  Created by leizh007 on 16/7/19.
//  Copyright © 2016年 HiPDA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let bootstrappingComponents: [Bootstrapping] = [
        ResourcesInitialization(),
        CrashAnalysis(),
        UIAppearanceManager(),
        URLProtocolManager(),
        LoginManager(),
        BackgroundFetchManager.shared
    ]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window?.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        bootstrap()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        let settins = Settings.shared
        settins.save()
        CacheManager.save()
        NetworkReachabilityManager.shared.stopListening()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NetworkReachabilityManager.shared.startListening()
        application.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        BackgroundFetchManager.shared.performFetch(with: completionHandler)
    }
}

// MARK: - 启动相关

extension AppDelegate {
    func bootstrap() {
        do {
            try bootstrapped(components: bootstrappingComponents)
        } catch {
            assertionFailure("组件启动失败！")
        }
    }

    @discardableResult
    func bootstrapped(components: [Bootstrapping]) throws -> Bootstrapped {
        return try components.reduce(Bootstrapped(), { (bootstrapped, next) -> Bootstrapped in
            return try bootstrapped.bootstrap(component: next)
        })
    }
}
