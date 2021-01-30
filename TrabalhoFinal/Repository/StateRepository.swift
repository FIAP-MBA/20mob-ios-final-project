//
//  StateRepository.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit
import CoreData

protocol StateRepositoryProtocol {
    var delegate: StateRepositoryDelegate? { get set }
    
    func loadStates()
    func deleteState(by name: String)
    func save(stateName: String, stateTax: NSDecimalNumber)
    func update(state: State)
}

final class StateRepository: StateRepositoryProtocol {
    
    weak var delegate: StateRepositoryDelegate?
    
    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.persistentContainer.viewContext
    }
    
    //MARK: - Methods
    func loadStates() {
        if let states = getLocal() {
            delegate?.stateRepository(didUpdateStates: states)
        }
    }
    
    func save(stateName: String, stateTax: NSDecimalNumber) {
        persistLocal(stateName, stateTax)
    }
    
    func update(state: State) {
        persistLocal(state: state)
    }
    
    func deleteState(by name: String) {
        deleteLocal(by: name)
    }

    //MARK: - Core data methods
    private func deleteLocal(by name: String) {
        guard let context = context else { return }
        do {
            let fetchedRequest: NSFetchRequest<State> = State.fetchRequest()
            let cdStates = try context.fetch(fetchedRequest)
            if let index = cdStates.firstIndex(where: { $0.name == name }) {
                context.delete(cdStates[index])
                try context.save()
                delegate?.stateRepository(wasStateDeleted: true)
            }
        } catch {
            delegate?.stateRepository(didUpdateError: StateRepositoryError.deleteData)
        }
    }
    
    private func getLocal() -> [State]? {
        guard let context = context else { return nil }
        do {
            let fetchedRequest: NSFetchRequest<State> = State.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchedRequest.sortDescriptors = [sortDescriptor]
            
            return try context.fetch(fetchedRequest)
        } catch {
            delegate?.stateRepository(didUpdateError: StateRepositoryError.loadData)
            return nil
        }
    }
    
    private func persistLocal(state: State? = nil, _ name: String? = nil, _ tax: NSDecimalNumber? = nil) {
        guard let context = context else { return }
        do {
            let fetchedRequest: NSFetchRequest<State> = State.fetchRequest()
            let cdStates = try context.fetch(fetchedRequest)
            guard let index = cdStates.firstIndex(where: { $0.name == state?.name }) else {
                let cdState = State(context: context)
                cdState.name = name
                cdState.tax = tax
                cdState.id = UUID()
                try context.save()
                delegate?.stateRepository(wasStateSaved: true)
                return
            }
            cdStates[index].addStateData(state!)
            try context.save()
            delegate?.stateRepository(wasStateSaved: true)
        } catch {
            delegate?.stateRepository(didUpdateError: StateRepositoryError.saveData)
        }
    }
}

protocol StateRepositoryDelegate: AnyObject {
    func stateRepository(didUpdateError: Error)
    
    func stateRepository(didUpdateStates: [State])
    
    func stateRepository(wasStateDeleted: Bool)
    
    func stateRepository(wasStateSaved: Bool)
}

extension StateRepositoryDelegate {
    func stateRepository(didUpdateStates: [State]) {
        /* Not implemented */
    }
    
    func stateRepository(wasStateDeleted: Bool) {
        /* Not implemented */
    }
    
    func stateRepository(wasStateSaved: Bool) {
        /* Not implemented */
    }
}

private enum StateRepositoryError: Error {
    case deleteData, saveData, loadData
}

extension StateRepositoryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .loadData:
            return NSLocalizedString("Falha ao carregar os estados.", comment: "")
        case .saveData:
            return NSLocalizedString("Falha ao salvar o estado.", comment: "")
        case .deleteData:
            return NSLocalizedString("Falha ao excluir o estado.", comment: "")
        }
    }
}
