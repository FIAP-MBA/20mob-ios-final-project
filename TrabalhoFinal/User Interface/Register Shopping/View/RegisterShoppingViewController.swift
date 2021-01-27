//
//  RegisterShoppingViewController.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit
import CoreData

final class RegisterShoppingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var pvProductState: UIPickerView!
    @IBOutlet weak var tfProductValue: UITextField!
    @IBOutlet weak var swProductCard: UISwitch!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var btProductSave: UIButton!
    
    //MARK: - Properties
    var viewModel: RegisterShoppingViewModel?
    var alertText: Bool = false
    var alertNumber: Bool = false
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupData()
    }
    
    //MARK: - Methods
    private func setupView() {
        //Vinculando o UIPickerView a esta classe
        self.pvProductState.delegate = self
        self.pvProductState.dataSource = self
        
        // Do any additional setup after loading the view.
        ivProductImage.isUserInteractionEnabled = true
        ivProductImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
        tfProductName.delegate = self
        tfProductValue.delegate = self
    }
    
    private func setupData() {
        viewModel?.loadData()
    }
    
    @objc private func tapDone() {
        tfProductValue.resignFirstResponder()
    }
    
    @objc private func tapCancel() {
        tfProductValue.resignFirstResponder()
    }
    
    //Retorna o número de componentes do picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    //Retorna o número de linhas por componente do picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel?.statesCount ?? 0
    }
    
    //Retorna qual dado será inserido em cada linha
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel?.statesName(at: row)
    }
    
    //Recupera o valor selecionado no picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.setState(at: row)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (_) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (_) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func save(_ sender: Any) {
//        if product == nil {
//            product = Product(context: context)
//        }
//
//        alertText = !validateText(tfProductName.text)
//        if !alertText {
//            alertText = !validateText(tfProductValue.text)
//        }
//        alertNumber = !validateNumber(tfProductValue.text)
//
//        product?.name = tfProductName.text
//        product?.value = NSDecimalNumber(string: tfProductValue.text ?? "0.0")
//        //print(stateSelected)
//        product?.states = stateSelected
//        //print(product?.states?.name)
//        product?.isCredit = swProductCard.isOn
//        product?.image = ivProductImage.image?.jpegData(compressionQuality: 0.8)
//
//        do {
//            if alertText || alertNumber {
//                showAlert(alertText, alertNumber)
//            } else {
//                try context.save()
//            }
//
//        } catch {
//            print(error.localizedDescription)
//        }
//        navigationController?.popViewController(animated: true)
    }
    
    func showAlert(_ validateText: Bool, _ validateNumber: Bool ) {
        var text: String = ""
        
        if validateText && !validateNumber {
            text = "Todos os campos são obrigatórios, por favor, verifique se estão preenchidos!"
        } else if !validateText && validateNumber {
            text = "O campo de valor aceita apenas números. Por gentileza, verifique novamente!"
        } else if validateText && validateNumber {
            text = "Valores incorretos, por gentileza, verifique se há apenas números no campo de valor e se esqueceu de preencher algum outro campo!"
        }
        
        let alertController = UIAlertController(title: "ComprasUSA", message:
                                                    text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validateText(_ text: String?) -> Bool {
        guard let message = text else { return false }
        if message == "" || message.isEmpty {
            return false
        }
        return true
    }
    
    func validateNumber(_ text: String?) -> Bool {
        guard let number = text else { return false }
        return number.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
}

extension RegisterShoppingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            ivProductImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension RegisterShoppingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
