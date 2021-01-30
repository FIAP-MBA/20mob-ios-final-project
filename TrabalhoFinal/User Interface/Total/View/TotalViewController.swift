//
//  TotalViewController.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit

final class TotalViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lbTotalUSD: UILabel!
    @IBOutlet weak var lbTotalBRL: UILabel!
    
    //MARK: - Properties
    var viewModel = TotalViewModel()
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupData()
    }
    
    //MARK: - Methods
    private func setupView() {
        viewModel.delegate = self
        //Inicia valores com 0
        lbTotalUSD.text = "0.0"
        lbTotalBRL.text = "0.0"
    }
    
    private func showError(with message: String) {
        let alert = AlertUtil.errorAlert(title: "Atenção", message: message)
        present(alert, animated: true, completion: nil)
    }
    
    private func setupData() {
        viewModel.loadData()
    }
    
    private func fillData() {
        lbTotalUSD.text = viewModel.totalUSDValue
        lbTotalBRL.text = viewModel.totalBRLValue
    }
}

extension TotalViewController: TotalViewModelDelegate {
    func onSuccess() {
        DispatchQueue.main.async {
            self.fillData()
        }
    }
    
    func onError(with message: String) {
        DispatchQueue.main.async {
            self.showError(with: message)
        }
    }
}
