//
//  CoreDataStack.swift
//  weatherappdemo
//
//  Created by Sachin Rao on 20/01/20.

import Foundation
import CoreData

class  CoreDataStack {
    private static var coordinator: CoreDataStack?
    private  let moduleName = "CoreDataStore"
    
    var context : NSManagedObjectContext{
        let context = persistentContainer.viewContext
        context.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        return persistentContainer.viewContext
    }
    var persistentContainer: NSPersistentContainer
    public class func shared() -> CoreDataStack {
        if coordinator == nil {
            coordinator = CoreDataStack()
        }
        return coordinator!
    }
    
    private init() {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        persistentContainer = NSPersistentContainer(name: moduleName)
        configureStoreCoordinator()
    }
    
    private func configureStoreCoordinator(){
        let defaultURL = NSPersistentContainer.defaultDirectoryURL()
        let description = NSPersistentStoreDescription(url: defaultURL)
        description.type = NSSQLiteStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
    }
    
    // MARK: - Core Data Saving support
    public func saveContext() {
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
    
    /// Method to write the  ManagedObject to background
    /// - Parameter completionHandler: creates a new NSManagedObjectContext with the concurrencyType set to NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType.
    static func performBackgroundTask(_ completionHandler:@escaping (NSManagedObjectContext)->Void){
        CoreDataStack.shared().persistentContainer.performBackgroundTask(completionHandler)
    }
    
    /// Method to Read and modify the ManagedObjects
    /// - Parameter completionHandler: provides persistent view context to read and modify the managed object
    static func getContext()->NSManagedObjectContext{
        return CoreDataStack.shared().context
    }
}
