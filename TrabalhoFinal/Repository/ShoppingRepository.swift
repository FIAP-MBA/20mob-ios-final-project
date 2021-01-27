//
//  ShoppingRepository.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

protocol ShoppingRepositoryProtocol {
    var delegate: ShoppingRepositoryDelegate? { get set }
}

final class ShoppingRepository: ShoppingRepositoryProtocol {
    weak var delegate: ShoppingRepositoryDelegate?

}

protocol ShoppingRepositoryDelegate: AnyObject {
    
}

extension ShoppingRepositoryDelegate {
    
}

private enum ShoppingRepositoryError: Error {
    
}
