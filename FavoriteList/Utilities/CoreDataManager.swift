//
//  CoreDataManager.swift
//  FavoriteList
//
//  Created by Stanislav Lemeshaev on 08.01.2022.
//  Copyright © 2022 slemeshaev. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    
    private let entityName = "Person"
    
    // MARK: - Properties
    var people: [NSManagedObject] = []
    
    // MARK: - Interface
    func save(name: String) {
        let managedContext = managedContext()
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext) else {
            return
        }
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetch() {
        let managedContext = managedContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func removeAll() {
        let managedContext = managedContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        if let objects = try? managedContext.fetch(fetchRequest) {
            for object in objects {
                managedContext.delete(object)
            }
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        people.removeAll()
    }
    
    // MARK: - Private
    private func managedContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
