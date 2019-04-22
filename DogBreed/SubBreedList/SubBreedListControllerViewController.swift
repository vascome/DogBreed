//
//  SubBreedListControllerViewController.swift
//  DogBreed
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import UIKit

class SubBreedListControllerViewController: UIViewController {
    
    let viewModel: SubBreedListViewModel!
    
    private lazy var table: UITableView = {
        var view = UITableView(frame: self.view.bounds, style: .plain)
        view.separatorStyle = .singleLine
        view.backgroundColor = .white
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = UITableView.automaticDimension
        return view
    }()
    
    init(_ viewModel: SubBreedListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.view = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Breeds"
        self.view.addSubview(self.table)
        
        self.table.dataSource = self.viewModel
        self.table.delegate = self.viewModel
        
        table.reloadData()
    }
    
    func present(_ vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
