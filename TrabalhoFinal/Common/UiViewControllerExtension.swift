//
//  UIViewControllerExtension.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    
    //Variável para apontar ao AppDelegate
    var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    //Variável que dá acesso ao Managed Object Context, que pode ser acessado
    //através da propriedade viewContext da persistentContainer
    var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func showInputDialog(
        title:String? = nil,
        subtitle:String? = nil,
        actionTitle:String? = "Add",
        cancelTitle:String? = "Cancel",
        inputPlaceholder1:String? = nil,
        inputPlaceholder2:String? = nil,
        inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
        inputKeyboardType2:UIKeyboardType = UIKeyboardType.default,
        cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
        actionHandler: ((  _ :String?) -> Void)? = nil
    ) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (t1) in
            t1.placeholder = inputPlaceholder1
            t1.keyboardType = inputKeyboardType
        }
        
        alert.addTextField { (t2) in
            t2.placeholder = inputPlaceholder2
            t2.keyboardType = inputKeyboardType2
        }
        
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            guard let textField2 =  alert.textFields?.last else {
                actionHandler?(nil)
                
                return
            }
            
            let stateName = textField.text
            let decimalValue = textField2.text
            
            if self.validateNumber2(decimalValue) && self.validateText2(stateName) {
                
                let newState = State(context: self.context)
                
                newState.name = textField.text
                newState.tax = NSDecimalNumber(string: textField2.text ?? "0.0")
                
                try? self.context.save()
            } else {
                let alert = UIAlertController(title: "Valor Invalido", message: "Insira um valor valido", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
            }
            
            self.navigationController?.popViewController(animated: true)
            
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateNumber2(_ text: String?) -> Bool {
        guard let number = text else { return false }
        if number == "" || number.isEmpty {
            return false
        }
        return number.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func validateText2(_ text: String?) -> Bool {
        guard let message = text else { return false }
        if message == "" || message.isEmpty {
            return false
        }
        return true
    }
}
