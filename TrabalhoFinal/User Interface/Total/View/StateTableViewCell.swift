//
//  StateTableViewCell.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit



class StateTableViewCell: UITableViewCell{
    
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbTax: UILabel!
    
    func prepare (with estado: State){
        
        lbState.text = estado.name
        lbTax.text = "\(estado.tax ?? 0)"
        
    }
}
