//
//  AlertUtil.swift
//  TrabalhoFinal
//
//  Created by Valmir Junior on 27/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit

struct AlertUtil {
    static func errorAlert(title: String? = "Erro!", message: String?, onComplete: (() -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            onComplete?()
        })
        
        return alert
    }
}
