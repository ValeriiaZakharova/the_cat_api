//
//  Breed.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 01.04.2022.
//

import Foundation

struct Breed: Decodable {
    let id: String
    let name: String
    let origin: String
}

extension Breed: NameOwner { }
