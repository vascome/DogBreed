//
//  WeatherModel.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

public struct BreedImageResponse : Decodable {
    let status: String
    let message: [String]
}

public struct BreedResponse : Decodable {
    let status: String
    let message: Dictionary<String, [String]>
}
