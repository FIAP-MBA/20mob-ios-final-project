//
//  UiViewController+CoreData.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController{
    
    //Variável para apontar ao AppDelegate
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //Variável que dá acesso ao Managed Object Context, que pode ser acessado
    //através da propriedade viewContext da persistentContainer
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
        
    }
}
