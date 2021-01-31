//
//  ShoppingTableViewController.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit

final class ShoppingTableViewController: UITableViewController {
    
    //MARK: - Properties
    //Criando label que será a mensagem caso não tenham compras cadastradas
    let label = UILabel(frame: CGRect(x: 0, y:0, width: 200, height: 44))
    var viewModel = ShoppingViewModel()
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RegisterShoppingViewController {
            if segue.identifier == "edit" {
                vc.viewModel = viewModel.getRegisterShoppingViewModel(at: tableView.indexPathForSelectedRow)
                return
            }
            vc.viewModel = viewModel.getRegisterShoppingViewModel()
        }
    }
    
    //MARK: - Methods
    private func setupView() {
        //Definindo o texto e alinhamento da label
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
    }
    
    private func setupData() {
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    private func showError(with message: String) {
        let alert = AlertUtil.errorAlert(title: "Atenção", message: message)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = viewModel.productCount == 0 ? label : nil
        return viewModel.productCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ShoppingTableViewCell else {
            return UITableViewCell()
        }
        
        cell.prepare(with: viewModel.getShoppingCellViewModel(at: indexPath))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteProduct(at: indexPath)
        }
    }
}

//MARK: - ViewModel Delegate
extension ShoppingTableViewController: ShoppingViewModelDelegate {
    func onSuccess() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func onError(with message: String) {
        DispatchQueue.main.async {
            self.onError(with: message)
        }
    }
}
