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

//    TODO: for iCloud support. App Extension에서 iCloud 사용이 불가하여 아직은 쓸 수 없다.
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
//        
//        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        
//        // Set up iCloud in another thread
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
//            let iCloudEnableAppId = "iCloud.com.ebay.kr.gkhim.scrapper"
//            let dataFileName = "ItemScrapperCloud.sqlite"
//            
//            let iCloudDataDirectoryName = "Data.nosync"
//            let iCloudLogsDirectoryName = "Logs"
//            var fileManager = NSFileManager.defaultManager() as NSFileManager
//            var localStore = self.applicationDocumentsDirectory.URLByAppendingPathComponent(dataFileName)
//            var iCloud: NSURL = fileManager.URLForUbiquityContainerIdentifier(nil)! as NSURL
//            
//            var iCloudLogsPath: String = iCloud.path!.stringByAppendingPathComponent(iCloudDataDirectoryName)
//            if fileManager.fileExistsAtPath(iCloudLogsPath) == false {
//                var fileSystemError: NSError?
//                
//                fileManager.createDirectoryAtPath(iCloudLogsPath, withIntermediateDirectories: true, attributes: nil, error: &fileSystemError)
//            }
//            
//            var iCloudData: String = iCloudLogsPath.stringByAppendingPathComponent(dataFileName)
//            
//            var options: NSMutableDictionary = NSMutableDictionary()
//            options.setObject(NSNumber(bool: true), forKey: NSMigratePersistentStoresAutomaticallyOption)
//            options.setObject(NSNumber(bool: true), forKey: NSInferMappingModelAutomaticallyOption)
//            options.setObject(iCloudEnableAppId, forKey: NSPersistentStoreUbiquitousContentNameKey)
//            options.setObject(iCloudLogsPath, forKey: NSPersistentStoreUbiquitousContentNameKey)
//            
//            coordinator?.lock()
//            
//            coordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: localStore, options: options, error: nil)
//            
//            coordinator?.unlock()
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                NSNotificationCenter.defaultCenter().postNotificationName("DataChanged", object: self, userInfo: nil)
//            })
//        })
//        
//        return coordinator
//    }()
//    
//    lazy var managedObjectContext: NSManagedObjectContext? = {
//
//        let coordinator = self.persistentStoreCoordinator
//        
//        if coordinator != nil {
//            var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
//            
//            managedObjectContext.performBlockAndWait({
//                managedObjectContext.persistentStoreCoordinator = coordinator
//                NSNotificationCenter.defaultCenter().addObserver(self, selector: "mergeChangesFromiCloud:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: coordinator)
//            })
//            
//            return managedObjectContext
//            
//        } else {
//            return nil
//        }
//    }()
//    
//    func mergeChangesFromiCloud(notification: NSNotification) {
//        var managedObjectContext: NSManagedObjectContext = self.managedObjectContext!
//        
//        managedObjectContext.performBlock({
//            managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
//            var refreshNotification: NSNotification = NSNotification(name: "DataChanged", object: self, userInfo: notification.userInfo)
//            
//            NSNotificationCenter.defaultCenter().postNotification(refreshNotification)
//        })
//    }
    
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

