//
//  ProductExtension.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

extension Product {
    func addProductData(_ product: Product) {
        self.id = product.id
        self.image = product.image
        self.isCredit = product.isCredit
        self.name = product.name
        self.state = product.state
        self.value = product.value
    }
}
