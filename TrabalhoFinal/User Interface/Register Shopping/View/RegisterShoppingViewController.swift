//
//  RegisterShoppingViewController.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit

final class RegisterShoppingViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var pvProductState: UIPickerView!
    @IBOutlet weak var tfProductValue: UITextField!
    @IBOutlet weak var swProductCard: UISwitch!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var btProductSave: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Properties
    var viewModel: RegisterShoppingViewModel?
    var alertText: Bool = false
    var alertNumber: Bool = false
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupData()
    }
    
    //MARK: - Methods
    private func setupView() {
        //Vinculando o UIPickerView a esta classe
        pvProductState.delegate = self
        pvProductState.dataSource = self
        viewModel?.delegate = self
        
        if viewModel?.isEditing ?? false {
            btProductSave.setTitle("Atualizar", for: .normal)
            title = "Atualizar Produto"
        }
        
        // Do any additional setup after loading the view.
        ivProductImage.isUserInteractionEnabled = true
        ivProductImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        
        tfProductName.delegate = self
        tfProductValue.delegate = self
    }
    
    private func setupData() {
        viewModel?.loadData()
    }
    
    private func selectPicture(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func showError(with message: String) {
        let alert = AlertUtil.errorAlert(title: "Atenção", message: message)
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func tapDone() {
        tfProductValue.resignFirstResponder()
    }
    
    @objc private func tapCancel() {
        tfProductValue.resignFirstResponder()
    }
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
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
    
    private func showAlert(_ validateText: Bool, _ validateNumber: Bool ) {
        var text: String = ""
        
        if validateText && !validateNumber {
            text = "Todos os campos são obrigatórios, por favor, verifique se estão preenchidos!"
        } else if !validateText && validateNumber {
            text = "O campo de valor aceita apenas números. Por gentileza, verifique novamente!"
        } else if validateText && validateNumber {
            text = "Valores incorretos, por gentileza, verifique se há apenas números no campo de valor e se esqueceu de preencher algum outro campo!"
        }
        
        let alertController = UIAlertController(title: "ComprasUSA", message: text, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func validateText(_ text: String?) -> Bool {
        guard let message = text else { return false }
        if message == "" || message.isEmpty {
            return false
        }
        return true
    }
    
    private func validateNumber(_ text: String?) -> Bool {
        guard let number = text else { return false }
        return Double(number) != nil
    }
    
    private func fillData() {
        tfProductName.text = viewModel?.name
        tfProductValue.text = viewModel?.value
        swProductCard.isOn = viewModel?.isCredit ?? false
        if let data = viewModel?.image {
            ivProductImage.image = UIImage(data: data)
        }
        pvProductState.selectRow(viewModel?.state ?? 0, inComponent: 0, animated: true)
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
    @IBAction func save(_ sender: Any) {
        alertText = !validateText(tfProductName.text)
        if !alertText {
            alertText = !validateText(tfProductValue.text)
        }
        alertNumber = !validateNumber(tfProductValue.text)
        
        viewModel?.set(name: tfProductName.text!)
        viewModel?.set(value: NSDecimalNumber(string: tfProductValue.text ?? "0.0"))
        viewModel?.set(isCredit: swProductCard.isOn)
        viewModel?.set(image: ivProductImage.image?.jpegData(compressionQuality: 0.8))
        viewModel?.set(row: pvProductState.selectedRow(inComponent: 0))
        
        if alertText || alertNumber {
            showAlert(alertText, alertNumber)
            return
        }
        viewModel?.saveProduct()
    }
}

//MARK: - ViewModel delegate
extension RegisterShoppingViewController: RegisterShoppingViewModelDelgate {
    func onSuccessLoadStates() {
        DispatchQueue.main.async {
            self.pvProductState.reloadAllComponents()
        }
    }
    
    func onSuccessSave() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func onSuccessLoadProduct() {
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

//MARK: - UIPickerView delegate
extension RegisterShoppingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
}

//MARK: - Image Picker delegate
extension RegisterShoppingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            ivProductImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - TextField Delegate
extension RegisterShoppingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
