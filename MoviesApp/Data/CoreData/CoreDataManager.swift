//
//  CoreDataManager.swift
//  MoviesApp
//
//  Created by Игорь Пинаев on 20/06/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation
import CoreData


var movies: [Movie] {
    let request = NSFetchRequest<Movie>(entityName: "Movie")
    
    let array = try? CoreDataManager.sharedInstance.managedObjectContext.fetch(request)
    
    if array != nil {
        return array!
    }
        return []
}

class CoreDataManager {
    static let sharedInstance = CoreDataManager()
    
    var managedObjectContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoviesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func clear(sotring: String) {
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "sorting = %@", sotring)
        
        do {
            let array = try managedObjectContext.fetch(fetchRequest)
            
            for movie in array {
                managedObjectContext.delete(movie)
            }
        } catch {
            
        }
    }
}
