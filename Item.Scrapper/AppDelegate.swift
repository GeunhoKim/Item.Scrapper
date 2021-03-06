//
//  AppDelegate.swift
//  Item.Scrapper
//
//  Created by geunho.khim on 2014. 9. 28..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MSDynamicsDrawerViewControllerDelegate {
    
    var window: UIWindow?
    var drawerViewController: MSDynamicsDrawerViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let navigationController = self.window!.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("Nav") as UINavigationController
        let masterViewController = navigationController.topViewController as MasterViewController
        
        masterViewController.managedObjectContext = self.managedObjectContext
        
        self.drawerViewController = self.window!.rootViewController as? MSDynamicsDrawerViewController
        self.drawerViewController?.delegate = self
        self.drawerViewController?.paneDragRequiresScreenEdgePan = true;
        self.drawerViewController?.screenEdgePanCancelsConflictingGestures = true;
        self.drawerViewController?.addStylersFromArray([MSDynamicsDrawerFadeStyler.styler(), MSDynamicsDrawerScaleStyler.styler(), MSDynamicsDrawerShadowStyler.styler()], forDirection: MSDynamicsDrawerDirection.Left)
        self.drawerViewController?.view.backgroundColor = UIColor.whiteColor()
        
        var menuViewController: MenuViewController = self.window!.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("Menu") as MenuViewController
        menuViewController.dynamicsDrawerViewController = self.drawerViewController
        masterViewController.dynamicsDrawerViewController = self.drawerViewController
        masterViewController.menuViewController = menuViewController;
        
        self.drawerViewController?.setDrawerViewController(menuViewController, forDirection: MSDynamicsDrawerDirection.Left)
        self.drawerViewController?.setPaneViewController(navigationController, animated: false, completion: nil)
        
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.ebay.kr.gkhim.scrapper")
        return url!
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("ItemScrapper", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("ItemScrapper.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(error), \(error!.userInfo)")
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                NSLog("Unresolved error \(error), \(error!.userInfo)")
            }
        }
    }
    
}

