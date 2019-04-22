//
//  ForecastEndPoint.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

public enum DogEndPoint {
    case getAllBreeds
    case getBreedImageList(breed: String)
    case getSubBreedImageList(breed: String, subBreed: String)
}


extension DogEndPoint : EndPointType {
    public var baseURL: URL {
        return URL(string: "https://dog.ceo/api")!
    }
    public var path: String {
        
        switch self {
        case .getAllBreeds:
            return "breeds/list/all"
        case .getBreedImageList(let breed):
            return "breed/\(breed)/images"
        case .getSubBreedImageList(let breed, let sub):
            return "breed/\(breed)/\(sub)/images"
        }
        
    }
    public var httpMethod: HTTPMethod { return .get }
    
    public var queries: HTTPQueries? {
        return nil
    }
}

