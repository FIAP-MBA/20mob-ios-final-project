//
//  StateViewModel.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import Foundation

final class StateViewModel {
    private let state: State
    
    var name: String {
        state.name ?? ""
    }
    var tax: String {
        "\(state.tax ?? 0)"
    }
    
    init(state: State) {
        self.state = state
    }
}
