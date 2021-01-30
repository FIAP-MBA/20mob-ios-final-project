//
//  SettingsViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

protocol SettingsViewModelDelegate: AnyObject {
    func onSuccessStates()
    func onError(with message: String)
}

final class SettingsViewModel {
    //MARK: - Properties
    private var states: [State] = []
    private let ud = UserDefaults.standard
    private var repository: StateRepositoryProtocol
    
    weak var delegate: SettingsViewModelDelegate?
    
    var dolar: String? {
        ud.string(forKey: UserDefaultKeys.dolar.rawValue)
    }
    var iof: String? {
        ud.string(forKey: UserDefaultKeys.iof.rawValue)
    }
    var statesCount: Int {
        states.count
    }
    
    init(_ repository: StateRepositoryProtocol = StateRepository()) {
        self.repository = repository
        self.repository.delegate = self
    }
    
    //MARK: - Methods
    func getStateViewModel(at indexPath: IndexPath) -> StateViewModel {
        StateViewModel(state: states[indexPath.row])
    }
    
    func saveDolarAndIOF(_ dolar: String, _ iof: String) {
        ud.set(dolar, forKey: UserDefaultKeys.dolar.rawValue)
        ud.set(iof, forKey: UserDefaultKeys.iof.rawValue)
    }
    
    func delete(at IndexPath: IndexPath) {
        repository.deleteState(by: states[IndexPath.row].name!)
    }
    
    func save(stateName: String, stateTax: String) {
        if let state = states.first(where: { $0.name == stateName }) {
            repository.update(state: state)
            return
        }
        let tax = NSDecimalNumber(string: stateTax)
        repository.save(stateName: stateName, stateTax: tax)
    }
    
    func loadData() {
        repository.loadStates()
    }
}

//MARK: - State Repository Delegate
extension SettingsViewModel: StateRepositoryDelegate {
    func stateRepository(didUpdateError: Error) {
        delegate?.onError(with: didUpdateError.localizedDescription)
    }
    
    func stateRepository(didUpdateStates: [State]) {
        states = didUpdateStates
        delegate?.onSuccessStates()
    }
    
    func stateRepository(wasStateSaved: Bool) {
        if wasStateSaved {
            loadData()
        }
    }
    
    func stateRepository(wasStateDeleted: Bool) {
        if wasStateDeleted {
            loadData()
        }
    }
}
