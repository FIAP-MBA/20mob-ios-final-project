//
//  ShoppingViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

final class ShoppingViewModel {
    
    var productCount: Int {
        0
    }
    
    func loadData() {
        
    }
    
    func getRegisterShoppingViewModel(at: IndexPath? = nil) -> RegisterShoppingViewModel {
        RegisterShoppingViewModel()
    }
    
    func getShoppingCellViewModel() -> ShoppingCellViewModel {
        
    }
    
    func deleteProduct(at indexPath: IndexPath) {
        
    }
}
