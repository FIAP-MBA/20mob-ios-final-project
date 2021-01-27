//
//  ShoppingViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

final class ShoppingViewModel {
    private var products: [Product] = []
    
    var productCount: Int {
        0
    }
    
    func loadData() {
        
    }
    
    func getRegisterShoppingViewModel(at indexPath: IndexPath? = nil) -> RegisterShoppingViewModel {
        if let indexPath = indexPath {
            return RegisterShoppingViewModel(id: products[indexPath.row].id, isEditing: true)
        }
        return RegisterShoppingViewModel(id: nil, isEditing: false)
    }
    
    func getShoppingCellViewModel(at indexPath: IndexPath) -> ShoppingCellViewModel {
        ShoppingCellViewModel(product: products[indexPath.row])
    }
    
    func deleteProduct(at indexPath: IndexPath) {
        
    }
}
