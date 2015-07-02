/*
    Mobile Time Accounting
    Copyright (C) 2015

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?


    /*
        iOS function for launching application. Does some initial set up stuff, including the one time registration and navigation bar style.
        
        @methodtype Hook
        @pre -
        @post Basic application set up is fullfilled
    */
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        
        setUpOneTimeRegistration()
        setUpNavigationBarStyle()
        setUpTabBarStyle()
    
        return true
    }
    
    
    /*
        Function is setting up one time registration on first startup. After registration is over, the corosponding screen will be skipped from there on.
        
        @methodtype Command
        @pre -
        @post If user not registered yet, registration will be shown
    */
    func setUpOneTimeRegistration()
    {
        if profileDAO.isRegistered()
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("main") as! UITabBarController
            window?.rootViewController = mainViewController
        }
        else
        {
            println("not yet registered")
        }
    }
    
    
    /*
        Function is setting up navigation bar style, including bar colors.
        
        @methodtype Command
        @pre -
        @post Tab bar appearance is set
    */
    func setUpNavigationBarStyle()
    {
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = UIColor(red: 0, green: 55/255, blue: 91/255, alpha: 255)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    }
    
    
    /*
        Function is setting up tab bar style, including tint color.
        
        @methodtype Command
        @pre -
        @post UINavigation bar appearance is set
    */
    func setUpTabBarStyle()
    {
        UITabBar.appearance().tintColor = UIColor(red: 0, green: 55/255, blue: 91/255, alpha: 255)
    }

    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    
    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    
    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

