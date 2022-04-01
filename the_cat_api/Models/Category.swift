//
//  Category.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 25.03.2022.
//

import Foundation

struct Category: Decodable {
    let id: Int
    let name: String
}

extension Category: NameOwner { }
