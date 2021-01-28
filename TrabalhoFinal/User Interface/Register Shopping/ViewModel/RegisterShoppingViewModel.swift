//
//  RegisterShoppingViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

protocol RegisterShoppingViewModelDelgate: AnyObject {
    func onSuccessSave()
    func onSuccessLoadStates()
    func onSuccessLoadProduct()
    func onError(with message: String)
}

final class RegisterShoppingViewModel {
    //MARK: - Properties
    private var productRepository: ProductRepositoryProtocol
    private var stateRepository: StateRepositoryProtocol
    private let id: UUID?
    private var product: Product?
    private var states: [State] = []
    let isEditing: Bool
    
    private var newProductName: String = ""
    private var newProductImage: Data?
    private var newProductIsCredit: Bool = false
    private var newProductValue: NSDecimalNumber?
    private var selectedState: State?
    
    weak var delegate: RegisterShoppingViewModelDelgate?
    
    var statesCount: Int {
        states.count
    }
    var name: String {
        product?.name ?? ""
    }
    var image: Data? {
        product?.image
    }
    var isCredit: Bool {
        product?.isCredit ?? false
    }
    var value: String {
        "\(product?.value ?? 0.00)"
    }
    var state: Int {
        if let product = product, let state = product.state {
            return states.firstIndex(of: state) ?? 0
        }
        return 0
    }
    
    init(id: UUID?, isEditing: Bool, _ productRepository: ProductRepositoryProtocol = ProductRepository(), _ stateRepository: StateRepositoryProtocol = StateRepository()) {
        self.id = id
        self.productRepository = productRepository
        self.stateRepository = stateRepository
        self.isEditing = isEditing
        
        self.productRepository.delegate = self
        self.stateRepository.delegate = self
    }
    
    //MARK: - Methods
    func loadData() {
        stateRepository.loadStates()
        if isEditing {
            productRepository.loadProduct(by: id!)
        }
    }
    
    func statesName(at row: Int) -> String? {
        states[row].name
    }
    
    func setState(at row: Int) {
        selectedState = states.count > 0 ? states[row] : nil
    }
    
    func set(name: String) {
        if isEditing {
            product?.name = name
            return
        }
        newProductName = name
    }
    
    func set(value: NSDecimalNumber) {
        if isEditing {
            product?.value = value
            return
        }
        newProductValue = value
    }
    
    func set(isCredit: Bool) {
        if isEditing {
            product?.isCredit = isCredit
            return
        }
        newProductIsCredit = isCredit
    }
    
    func set(image: Data?) {
        if isEditing {
            product?.image = image
            return
        }
        newProductImage = image
    }
    
    func saveProduct() {
        if isEditing {
            productRepository.update(product: product!)
            return
        }
        productRepository.save(
            name: newProductName,
            image: newProductImage,
            isCredit: newProductIsCredit,
            value: newProductValue,
            state: selectedState
        )
    }
}

//MARK: - Product Repository Delegate
extension RegisterShoppingViewModel: ProductRepositoryDelegate {
    func productRepository(didUpdateError: Error) {
        delegate?.onError(with: didUpdateError.localizedDescription)
    }
    
    func productRepository(wasProductSaved: Bool) {
        if wasProductSaved {
            delegate?.onSuccessSave()
        }
    }
}

//MARK: - State Repository Delegate
extension RegisterShoppingViewModel: StateRepositoryDelegate {
    func stateRepository(didUpdateError: Error) {
        delegate?.onError(with: didUpdateError.localizedDescription)
    }
    
    func stateRepository(didUpdateStates: [State]) {
        states = didUpdateStates
        delegate?.onSuccessLoadStates()
    }
}
