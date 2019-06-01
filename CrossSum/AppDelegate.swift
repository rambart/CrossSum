//
//  AppDelegate.swift
//  CrossSum
//
//  Created by Tom on 5/22/19.
//  Copyright © 2019 Tom. All rights reserved.
//

import UIKit


// This app's adMobID ca-app-pub-8018625094361074~7751354248

let intersitialAdID = "ca-app-pub-3940256099942544/4411468910"
// CrossSum ad unit: "ca-app-pub-8018625094361074/8682837125"
// test interstitial unit: "ca-app-pub-3940256099942544/4411468910"

let bannerAdID = "ca-app-pub-3940256099942544/2934735716"
// CrossSum ad unit: "ca-app-pub-8018625094361074/4803194060"
// test banner ad: "ca-app-pub-3940256099942544/2934735716"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var puzzle = Puzzle()
    var pen = [0, 0, 0, 0, 0, 0, 0, 0, 0]
    var pencil = ["", "", "", "", "", "", "", "", ""]
    var pointPenalty = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        puzzle.savePuzzle(pen: pen, pencil: pencil, pointPenalty: pointPenalty)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let load = loadPuzzle()
        puzzle = load.puzzle
        pen = load.pen
        pencil = load.pencil
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    


}

