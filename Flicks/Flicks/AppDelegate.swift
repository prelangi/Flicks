//
//  AppDelegate.swift
//  Flicks
//
//  Created by Prasanthi Relangi on 2/5/16.
//  Copyright © 2016 prasanthi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cantaloupeColor = UIColor(red: 242/255.0, green: 187/255.0, blue: 97/255.0, alpha: 1.0)

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Disable caching, so that we can demonstrate features related to making actual requests.
        let sharedCache = NSURLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        NSURLCache.setSharedURLCache(sharedCache)
        //[NSURLCache setSharedURLCache:sharedCache];

        // Override point for customization after application launch.
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        //window?.tintColor = UIColor.yellowColor()
        
        //Reference the storyboard in the app
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let nowPlayingNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let nowPlayingViewController = nowPlayingNavigationController.topViewController as! MoviesViewController
        nowPlayingViewController.endPoint = "now_playing"
        nowPlayingNavigationController.tabBarItem.title = "Now Playing"
        nowPlayingNavigationController.tabBarItem.image = UIImage(named:"Film-24")
        nowPlayingNavigationController.navigationBar.barTintColor = cantaloupeColor
        
        let topRatedNavigationController = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
        let topRatedViewController = topRatedNavigationController.topViewController as! MoviesViewController
        topRatedViewController.endPoint = "top_rated"
        topRatedViewController.title = "Top Rated"
        topRatedNavigationController.tabBarItem.title = "Top Rated"
        topRatedNavigationController.tabBarItem.image = UIImage(named:"Outlined Star-24")
        topRatedNavigationController.navigationBar.barTintColor = cantaloupeColor
        

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNavigationController,topRatedNavigationController]
        
        UITabBar.appearance().barTintColor = cantaloupeColor
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

