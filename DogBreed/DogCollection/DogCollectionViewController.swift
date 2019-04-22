//
//  DogCollectionViewController.swift
//  DogBreed
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import UIKit

class DogCollectionViewController: UIViewController {

    let viewModel: DogCollectionViewModel!
    
    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.itemSize = CGSize(width: (self.view.bounds.size.width-8)/2, height: 150)
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return view
    }()
    
    init(_ viewModel: DogCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Dog pictures"
        self.view.addSubview(self.collection)
        self.collection.dataSource = viewModel
        self.collection.register(UINib(nibName: "DogViewCell", bundle: nil), forCellWithReuseIdentifier: "DogViewCell")
        viewModel.fetchDogImageList()
    }
    
    func reload() {
        collection.reloadData()
    }
    
}
