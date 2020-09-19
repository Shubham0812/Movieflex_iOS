//
//  AppDelegate.swift
//  Movieflex
//
//  Created by Shubham Singh on 15/09/20.
//  Copyright © 2020 Shubham Singh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

// If the API Response is 429 -> Create a new token with your credentials here -https://rapidapi.com/apidojo/api/imdb8/ . Replace the apiKey and the APIs will work again

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK:- variables for the AppDelegate
    var window: UIWindow?
    
    // MARK:- functions for the AppDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let popularList = UserDefaultsManager().getPopularTitlesList()
        if (popularList.isEmpty) {
            NetworkManager().getPopularTitles { res, error in
                if (error == nil) {
                    guard let titleIds = res else { return }
                    UserDefaultsManager().setPopularTitlesList(titles: titleIds)
                }
            }
        }
        
        let comingSoonList = UserDefaultsManager().getComingSoonTitlesList()
        if (comingSoonList.isEmpty) {
            NetworkManager().getComingSoonTitles { res, error in
                if (error == nil) {
                    guard let titleIds = res else { return }
                    UserDefaultsManager().setComingSoonitlesList(titles: titleIds)
                }
            }
        }

        return true
    }
    
    
    // MARK: - functions for CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Movieflex")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

