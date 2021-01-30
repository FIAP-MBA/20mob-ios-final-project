//
//  SettingsViewController.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    //MARK: - Properties
    var label = UILabel(frame: CGRect(x: 0, y:0, width: 200, height: 22))
    var viewModel = SettingsViewModel()
    
    //MARK: - IBOutlets
    @IBOutlet weak var tfDolar1: UITextField!
    @IBOutlet weak var tfIof1: UITextField!
    @IBOutlet weak var tvTax: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tfDolar1.text = viewModel.dolar
        tfIof1.text = viewModel.iof
    }
        
    //MARK: - Methods
    func setupView() {
        tvTax.dataSource = self
        tvTax.delegate = self
        
        tfDolar1.delegate = self
        tfIof1.delegate = self
        
        tfDolar1.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.tapDone)), onCancel: (target: self, action: #selector(self.tapCancel)))
        
        tfIof1.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.tapDone)), onCancel: (target: self, action: #selector(self.tapCancel)))
    }
    
    func setupData() {
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    @objc func tapDone() {
        viewModel.saveDolarAndIOF(tfDolar1.text!, tfIof1.text!)
    }
    
    @objc func tapCancel() {
        hideKeyboard()
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }

    private func validateNumber2(_ text: String?) -> Bool {
        guard let number = text else { return false }
        if number == "" || number.isEmpty {
            return false
        }
        return Double(number) != nil
    }
    
    private func validateText2(_ text: String?) -> Bool {
        guard let message = text else { return false }
        if message == "" || message.isEmpty {
            return false
        }
        return true
    }
    
    private func showError(with message: String) {
        let alert = AlertUtil.errorAlert(title: "Atenção", message: message)
        present(alert, animated: true, completion: nil)
    }
    
    private func createDialog(title: String, message: String?, btDoneAction: String, previousInputed1: String = "", previousInputed2: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Nome do estado"
            textField.keyboardType = .default
            textField.text = previousInputed1
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Imposto"
            textField.keyboardType = .decimalPad
            textField.text = previousInputed2
        }
        
        alert.addAction(UIAlertAction(title: btDoneAction, style: .default, handler: { action in
            guard let textField = alert.textFields?.first else { return }
            guard let textField2 = alert.textFields?.last else { return }
            
            let stateName = textField.text!
            let decimalValue = textField2.text!
            
            if self.validateNumber2(decimalValue) && self.validateText2(stateName) {
                self.viewModel.save(stateName: stateName, stateTax: decimalValue)
            } else {
                let alert = UIAlertController(title: "Valor Invalido", message: "Insira um valor valido", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    //MARK: - IBActions
    @IBAction func btAddEstado(_ sender: UIButton) {
        createDialog(title: "Adicionar Estado", message: nil, btDoneAction: "Adicionar")
    }
}

//MARK: - TableView delegate and datasource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.statesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StateTableViewCell else { return UITableViewCell()}
        
        cell.prepare(with: viewModel.getStateViewModel(at: indexPath))

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.delete(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tvTax.cellForRow(at: indexPath) as? StateTableViewCell else { return }
        
        createDialog(
            title: "Editar Estado",
            message: nil,
            btDoneAction: "Salvar",
            previousInputed1: cell.lbState.text!,
            previousInputed2: cell.lbTax.text!
        )
    }
}

//MARK: - TextField delegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.saveDolarAndIOF(tfDolar1.text!, tfIof1.text!)
        textField.resignFirstResponder()
        return true
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func onSuccessStates() {
        DispatchQueue.main.async {
            self.tvTax.reloadData()
        }
    }
    
    func onError(with message: String) {
        DispatchQueue.main.async {
            self.showError(with: message)
        }
    }
}
