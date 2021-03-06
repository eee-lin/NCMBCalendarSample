//
//  AppDelegate.swift
//  CalendarSample
//
//  Created by 森川正崇 on 2020/05/07.
//  Copyright © 2020 morikawamasataka. All rights reserved.
//

import UIKit
import NCMB
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let applicationKey = "e2f18f26d14ca2c4ef78824ad99e31f2ce2619a3712bf040e713b90994cf4aa6"
        let clientkey = "a463e24f898a3ec6f1a4c5e2fbc06848ca126b5cd453c7be4d84e93ff67beb5b"
        NCMB.setApplicationKey(applicationKey, clientKey: clientkey)
        // Q1:userdefaultsを用いて，匿名ログイン時のuserIdを保存してください.また全てのユーザーに対してデータのアクセス権を与えるACL設定をしてください
        // Additional Q:可能な限りリファクタリングしてください
        if UserDefaults.standard.object(forKey: "userId") == nil {
            NCMBUser.enableAutomaticUser()
            NCMBUser.automaticCurrentUser { (user, error) in
                if error != nil {
                    print(error)
                } else {
                    UserDefaults.standard.set(user?.objectId, forKey: "userId")
                    let groupACL = NCMBACL()
                    groupACL.setPublicReadAccess(true)
                    user!.acl = groupACL
                    user!.save(nil)
                }
            }
        }
        return true
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


}

