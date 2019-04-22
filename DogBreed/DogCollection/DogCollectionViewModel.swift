//
//  DogCollectionViewModel.swift
//  DogBreed
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DogCollectionViewModel : NSObject {
    
    let gateway = DataGateway.shared
    
    weak var view : DogCollectionViewController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<DogImage> = {
        
        let fetchRequest = NSFetchRequest<DogImage>(entityName:"DogImage")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "uri", ascending:true)]
        if let parent = self.parentBreed {
            fetchRequest.predicate = NSPredicate(format: "subBreed.name==%@ AND subBreed.parent.name==%@", self.breed, parent)
        }
        else {
            fetchRequest.predicate = NSPredicate(format: "breed.name==%@", self.breed)
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: gateway.store.container.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return controller
    }()
    
    let breed:String
    let parentBreed: String?
    init(_ breed: String, _ parent:String?) {
        self.parentBreed = parent
        self.breed = breed
    }
    
    func fetchDogImageList() {
        if parentBreed != nil {
            gateway.getSubBreedImageList(parentBreed!, breed)
        }
        else {
            gateway.getBreedImageList(breed)
        }
        
    }
    
}

extension DogCollectionViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let image = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogViewCell", for: indexPath)
        if  let cell = cell as? DogViewCell {
            cell.setImageUri(image.uri!)
        }
        return cell
    }
    
}


extension DogCollectionViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.view?.reload()
    }
}
