//
//  NetworkGateway.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

public final class DataGateway {
    
    private let network = NetworkManager()
    public let store = StoreManager.shared
    public static let shared = DataGateway()
    private init () {}
    
    public func getBreedList() {
        
        let endPoint = DogEndPoint.getAllBreeds
        network.send(request: endPoint) { [weak self] (result: Result<BreedResponse, APIError>) in
            switch result {
            case .failure:
                break
            case .success(let breed):
                self?.store.writeBreeds(breed.message)
            }
        }
    }
    
    public func getBreedImageList(_ breed: String) {
        
        let endPoint = DogEndPoint.getBreedImageList(breed: breed)
        network.send(request: endPoint) { [weak self] (result: Result<BreedImageResponse, APIError>) in
            switch result {
            case .failure:
                break
            case .success(let response):
                self?.store.writeUri(response.message, for: breed)
            }
        }
    }
    
    public func getSubBreedImageList(_ breed: String ,_ subBreed: String) {
        
        let endPoint = DogEndPoint.getSubBreedImageList(breed: breed, subBreed: subBreed)
        network.send(request: endPoint) { [weak self] (result: Result<BreedImageResponse, APIError>) in
            switch result {
            case .failure:
                break
            case .success(let response):
                self?.store.writeUri(response.message, for: breed, andSub:subBreed)
            }
        }
    }
}
