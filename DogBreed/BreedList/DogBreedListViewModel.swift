//
//  DogBreedListViewModel.swift
//  DogBreed
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DogBreedListViewModel : NSObject {
    
    let gateway = DataGateway.shared
    
    weak var view : DogBreedListController?
    
    lazy var fetchedResultsController: NSFetchedResultsController<Breed> = {
        
        let fetchRequest = NSFetchRequest<Breed>(entityName:"Breed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending:true)]
        
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
    
    func fetchDogList() {
        gateway.getBreedList()
    }
    
}

extension DogBreedListViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.selectionStyle = .none
        }
        let breed = fetchedResultsController.object(at: indexPath)
        cell!.textLabel?.text = breed.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breed = fetchedResultsController.object(at: indexPath)
        if let child = breed.child, child.count > 0 {
            let viewModel = SubBreedListViewModel(breed.name!, child.allObjects as! [SubBreed])
            let vc = SubBreedListControllerViewController(viewModel)
            self.view?.present(vc)
        }
        else {
            
            let viewModel = DogCollectionViewModel(breed.name!, nil)
            let vc = DogCollectionViewController(viewModel)
            self.view?.present(vc)
        }
    }
}

extension DogBreedListViewModel: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.view?.reload()
    }
}

