//
//  StoreManager.swift
//  DogBreed
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation
import CoreData

public final class StoreManager {
    
    public static let shared = StoreManager()
    
    private lazy var backgroundContext : NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        return context
    }()
    
    public var container : NSPersistentContainer
    private init() {
        container = NSPersistentContainer(name: "DogModel")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
    }
    
    static func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        block(StoreManager.shared.backgroundContext)
    }
    
    static func performViewTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        block(StoreManager.shared.container.viewContext)
    }
    
    
    func writeBreeds(_ breeds: [String:[String]]) {
        
        StoreManager.performBackgroundTask { (context) in
            breeds.forEach({ (key: String, values: [String]) in
                
                let request : NSFetchRequest<Breed> = Breed.fetchRequest()
                request.predicate = NSPredicate(format: "name = %@", key)
                do {
                    let res = try context.fetch(request)
                    var obj : Breed
                    if res.count > 0 {
                        obj = res[0]
                    }
                    else {
                        obj = Breed(context: context)
                    }
                    obj.name = key
                    let set = NSMutableSet()
                    values.forEach({ value in
                        if let sub = obj.child,
                            sub.filtered(using: NSPredicate(format: "name==%@", value)).count > 0 {
                        }
                        else {
                            let subBreed = SubBreed(context: context)
                            subBreed.name = value
                            set.add(subBreed)
                        }
                    })
                    
                    if set.count > 0 {
                        obj.addToChild(set)
                    }
                }
                catch {
                    print("exception getting breed")
                }
            })
            if context.hasChanges {
                do {
                    try context.save()
                    print("saved changes")
                } catch {
                    print("exception saving in background thread")
                }
            }
        }
    }
    
    
    func writeUri(_ uri: [String], for breed: String) {

        StoreManager.performBackgroundTask { (context) in
            let request : NSFetchRequest<Breed> = Breed.fetchRequest()
            request.predicate = NSPredicate(format: "name == %@", breed)
            request.returnsObjectsAsFaults = false
            do {
                let res = try context.fetch(request)
                if let obj = res.first {
                    
                    let set = self.filterUriToStore(images: obj.images ?? NSSet(), uri: uri, in: context)
                    if set.count > 0 {
                        obj.addToImages(set)
                    }
                }
                
                if context.hasChanges {
                    try context.save()
                }
            }
            catch {
                print("exception store uris")
            }
            
        }
    }
    
    
    func writeUri(_ uri: [String], for breed: String, andSub subBreed: String) {
        
        StoreManager.performBackgroundTask { (context) in
            let request : NSFetchRequest<SubBreed> = SubBreed.fetchRequest()
            request.predicate = NSPredicate(format: "name==%@ AND parent.name==%@", subBreed, breed)
            request.returnsObjectsAsFaults = false
            do {
                let res = try context.fetch(request)
                if let obj = res.first {
                    let set = self.filterUriToStore(images: obj.images ?? NSSet(), uri: uri, in: context)
                    if set.count > 0 {
                        obj.addToImages(set)
                    }
                }
                
                if context.hasChanges {
                    try context.save()
                }
            }
            catch {
                print("exception store uris")
            }
            
        }
    }
    
    private func filterUriToStore(images: NSSet, uri:[String], in context: NSManagedObjectContext) -> NSSet {
        
        let set = NSMutableSet()
        uri.forEach({ (value) in
            
            if images.filtered(using: NSPredicate(format: "uri==%@", value)).count == 0 {
                let result = try? self.fetchDogImage(value, in: context)
                if let dogUri = result?.first {
                    dogUri.uri = value
                    set.add(dogUri)
                }
                else {
                    let dogUri = DogImage(context: context)
                    dogUri.uri = value
                    set.add(dogUri)
                }
            }
        })
        
        return set
    }
    
    
    private func fetchDogImage(_ uri:String, in context: NSManagedObjectContext) throws -> [DogImage] {
        let request : NSFetchRequest<DogImage> = DogImage.fetchRequest()
        request.predicate = NSPredicate(format: "uri = %@", uri)
        return try context.fetch(request)
    }
    
}


