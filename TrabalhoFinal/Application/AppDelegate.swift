//
//  AppDelegate.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 10/11/20.
//  Copyright © 2020 fiap. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //MARK: - CoreData Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ShoppingModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                //Handler error
                fatalError("Unresolved error \(error.localizedDescription)")
            }
        }
        
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

