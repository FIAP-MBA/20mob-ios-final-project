//
//  StateExtension.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

extension State {
    func addStateData(_ state: State) {
        self.name = state.name
        self.tax = state.tax
        self.products = state.products
    }
}
