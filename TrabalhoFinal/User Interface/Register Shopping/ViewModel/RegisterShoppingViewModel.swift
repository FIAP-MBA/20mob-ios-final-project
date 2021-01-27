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
    private var productRepository: ProductRepositoryProtocol
    private var stateRepository: StateRepositoryProtocol
    private let id: UUID?
    private var product: Product?
    private var states: [State] = []
    private var selectedState: State?
    let isEditing: Bool
    
    weak var delegate: RegisterShoppingViewModelDelgate?
    
    var statesCount: Int {
        states.count
    }
    var name: String {
        ""
    }
    var image: Data? {
        nil
    }
    var isCredit: Bool {
        false
    }
    var value: String {
        ""
    }
    var state: Int {
        0
    }
    
    init(id: UUID?, isEditing: Bool, _ productRepository: ProductRepositoryProtocol = ProductRepository(), _ stateRepository: StateRepositoryProtocol = StateRepository()) {
        self.id = id
        self.productRepository = productRepository
        self.stateRepository = stateRepository
        self.isEditing = isEditing
        
        self.productRepository.delegate = self
        self.stateRepository.delegate = self
    }
    
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
        selectedState = states[row]
    }
    
    func set(name: String) {
        
    }
    
    func set(value: NSDecimalNumber) {
        
    }
    
    func set(isCredit: Bool) {
        
    }
    
    func set(image: Data?) {
        
    }
    
    func saveProduct() {
        
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
