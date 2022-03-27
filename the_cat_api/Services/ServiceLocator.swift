//
//  ServiceLocator.swift
//  the_cat_api
//
//  Created by Valeriia Zakharova on 26.03.2022.
//

import Foundation

class ServiceLocator {

    static let shared = ServiceLocator()

    let categoriesService: CategoriesService
    let imageService: ImageService

    init() {
        let networkProvider = NetworkProvider.shared

        categoriesService = networkProvider
        imageService = networkProvider
    }
}
