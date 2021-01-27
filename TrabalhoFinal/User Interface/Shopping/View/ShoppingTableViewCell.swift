//
//  ShoppingTableViewCell.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit

class ShoppingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbProductName: UILabel!
    @IBOutlet weak var lbProductValue: UILabel!
    @IBOutlet weak var ivProductImage: UIImageView!
    
    
    func prepare(with viewModel: ShoppingCellViewModel) {
        lbProductName.text = viewModel.name
        lbProductValue.text = viewModel.value
        
        //Se houver imagem cadastrada, recuperamos e geramos a UIImage baseado no dado
        if let data = viewModel.image {
            ivProductImage.image = UIImage(data: data)
        }
    }
    
}
