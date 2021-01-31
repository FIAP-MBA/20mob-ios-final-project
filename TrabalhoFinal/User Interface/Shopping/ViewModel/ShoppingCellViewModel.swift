//
//  ShoppingCellViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

final class ShoppingCellViewModel {
    private let product: Product
    
    var name: String {
        product.name ?? ""
    }
    var value: String {
        "\(product.value ?? 0.00)"
    }
    var image: Data? {
        product.image
    }
    
    init(product: Product) {
        self.product = product
    }
}
