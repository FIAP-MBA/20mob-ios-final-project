//
//  ShoppingTableViewController.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit
import CoreData

class ShoppingTableViewController: UITableViewController {
    
    //Criando label que será a mensagem caso não tenham compras cadastradas
    var label = UILabel(frame: CGRect(x: 0, y:0, width: 200, height: 44))
    
    //Criando o objeto que fará requisições ao contexto, realizando solicitações ao entities criados
    var fetchedResultController: NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Definindo o texto e alinhamento da label
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        
        //Carregando a lista de compras
        loadProducts()
    }
    
    func loadProducts() {
        //Criando um objeto de requisição que será feita através da fetchedResultController
        //Essa request pode ser criada a partir do método da própria model
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        //Definindo o tipo de ordenação da busca. Aqui, definimos ordenação ascendente por name
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true )
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Instanciando NSFetchedResultsController, passando as informações de fetchRequest
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //Definimos nossa ShoppingTableViewController como delegate da fetchedRèsultController
        fetchedResultController.delegate = self
        do {
            //Executando a requisição
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit" {
            if let vc = segue.destination as? RegisterShoppingViewController {
                vc.product = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
            }
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Caso existam objetos recuperados pela fetchedResultController, preparamos a tableView
        if let count = fetchedResultController.fetchedObjects?.count {
            tableView.backgroundView = count == 0 ? label : nil
            return count
        } else {
            tableView.backgroundView = label
            return 0
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
                ShoppingTableViewCell else {
            return UITableViewCell()
        }
        
        //Recuperando da fetchedResultController o produto referente à célula
        let product  = fetchedResultController.object(at: indexPath)
        
        cell.prepare(with: product)
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultController.object(at: indexPath)
            
            //Excluindo o produto do contexto
            context.delete(product)
            
            do {
                //Persistindo a exclusão
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
}

//Implementando o protocolo NSFetchedResultsControllerDelegate
extension ShoppingTableViewController: NSFetchedResultsControllerDelegate {
    
    //Método que é chamado sempre que uma alteração é feita no contexto
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

