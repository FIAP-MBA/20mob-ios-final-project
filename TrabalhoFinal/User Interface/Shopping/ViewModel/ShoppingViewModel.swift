//
//  ShoppingViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

protocol ShoppingViewModelDelegate: AnyObject {
    func onSuccess()
    func onError(with message: String)
}

final class ShoppingViewModel {
    //MARK: - Properties
    private var products: [Product] = []
    private var repository: ProductRepositoryProtocol
    
    weak var delegate: ShoppingViewModelDelegate?
    
    var productCount: Int {
        products.count
    }
    
    init(_ repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
        self.repository.delegate = self
    }
    
    //MARK: - Methods
    func loadData() {
        repository.loadProducts()
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
        repository.deleteProduct(by: products[indexPath.row].id!)
    }
}

//MARK: - Product Repository Delegate
extension ShoppingViewModel: ProductRepositoryDelegate {
    func productRepository(didUpdateError: Error) {
        delegate?.onError(with: didUpdateError.localizedDescription)
    }
    
    func productRepository(didUpdateProducts: [Product]) {
        products = didUpdateProducts
        delegate?.onSuccess()
    }
    
    func productRepository(wasProductDeleted: Bool) {
        loadData()
    }
}
