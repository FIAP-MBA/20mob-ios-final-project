//
//  ProductRepository.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit
import CoreData

protocol ProductRepositoryProtocol {
    var delegate: ProductRepositoryDelegate? { get set }
    
    func loadProducts()
    func loadProduct(by id: UUID)
    func deleteProduct(by id: UUID)
    func save(product: Product)
    func update(product: Product)
}

final class ProductRepository: ProductRepositoryProtocol {
    
    weak var delegate: ProductRepositoryDelegate?
    
    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: - Methods
    func loadProducts() {
        if let products = getLocal() {
            delegate?.productRepository(didUpdateProducts: products)
        }
    }
    
    func loadProduct(by id: UUID) {
        if let products = getLocal() {
            if let index = products.firstIndex(where: { $0.id == id }) {
                delegate?.productRepository(didUpdateProduct: products[index])
                return
            }
            delegate?.productRepository(didUpdateError: ProductRepositoryError.loadSingleData)
        }
    }
    
    func save(product: Product) {
        persistLocal(product: product)
    }
    
    func update(product: Product) {
        persistLocal(product: product)
    }
    
    func deleteProduct(by id: UUID) {
        deleteLocal(by: id)
    }

    //MARK: - Core data methods
    private func deleteLocal(by id: UUID) {
        guard let context = context else { return }
        do {
            let fetchedRequest: NSFetchRequest<Product> = Product.fetchRequest()
            let cdProduct = try context.fetch(fetchedRequest)
            if let index = cdProduct.firstIndex(where: { $0.id == id }) {
                context.delete(cdProduct[index])
                try context.save()
                delegate?.productRepository(wasProductDeleted: true)
            }
        } catch {
            delegate?.productRepository(didUpdateError: ProductRepositoryError.deleteData)
        }
    }
    
    private func getLocal() -> [Product]? {
        guard let context = context else { return nil }
        do {
            let fetchedRequest: NSFetchRequest<Product> = Product.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchedRequest.sortDescriptors = [sortDescriptor]
            
            return try context.fetch(fetchedRequest)
        } catch {
            delegate?.productRepository(didUpdateError: ProductRepositoryError.loadData)
            return nil
        }
    }
    
    private func persistLocal(product: Product) {
        guard let context = context else { return }
        do {
            let fetchedRequest: NSFetchRequest<Product> = Product.fetchRequest()
            let cdProducts = try context.fetch(fetchedRequest)
            guard let index = cdProducts.firstIndex(where: { $0.id == product.id }) else {
                let cdProduct = Product(context: context)
                cdProduct.addProductData(product)
                try context.save()
                delegate?.productRepository(wasProductSaved: true)
                return
            }
            cdProducts[index].addProductData(product)
            try context.save()
            delegate?.productRepository(wasProductSaved: true)
        } catch {
            delegate?.productRepository(didUpdateError: ProductRepositoryError.saveData)
        }
    }
}

protocol ProductRepositoryDelegate: AnyObject {
    func productRepository(didUpdateError: Error)
    
    func productRepository(didUpdateProducts: [Product])
    
    func productRepository(didUpdateProduct: Product)
    
    func productRepository(wasProductDeleted: Bool)
    
    func productRepository(wasProductSaved: Bool)
}

extension ProductRepositoryDelegate {
    func productRepository(didUpdateProducts: [Product]) {
        /* Not implemented */
    }
    
    func productRepository(didUpdateProduct: Product) {
        /* Not implemented */
    }
    
    func productRepository(wasProductDeleted: Bool) {
        /* Not implemented */
    }
    
    func productRepository(wasProductSaved: Bool) {
        /* Not implemented */
    }
}

private enum ProductRepositoryError: Error {
    case deleteData, saveData, loadData, loadSingleData
}

extension ProductRepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .loadData:
            return NSLocalizedString("Falha ao carregar os produtos.", comment: "")
        case .loadSingleData:
            return NSLocalizedString("Falha ao carregar o produto.", comment: "")
        case .saveData:
            return NSLocalizedString("Falha ao salvar o produto.", comment: "")
        case .deleteData:
            return NSLocalizedString("Falha ao excluir o produto.", comment: "")
        }
    }
}
