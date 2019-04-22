//
//  SubBreedListViewModel.swift
//  DogBreed
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation
import UIKit

class SubBreedListViewModel : NSObject {
    
    weak var view : SubBreedListControllerViewController?
    
    let breeds:[SubBreed]
    let parentBreed: String
    init(_ breed: String, _ breeds:[SubBreed]) {
        self.parentBreed = breed
        self.breeds = breeds
    }
    
}

extension SubBreedListViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.selectionStyle = .none
        }
        let breed = breeds[indexPath.row]
        cell!.textLabel?.text = breed.name
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let breed = breeds[indexPath.row]
        let viewModel = DogCollectionViewModel(breed.name!, parentBreed)
        let vc = DogCollectionViewController(viewModel)
        self.view?.present(vc)
    }
}
