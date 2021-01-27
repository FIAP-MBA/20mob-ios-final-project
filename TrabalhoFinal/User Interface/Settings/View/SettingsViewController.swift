//
//  SettingsViewController.swift
//  TrabalhoFinal
//
//  Created by Rafael Barros on 21/01/21.
//  Copyright © 2021 fiap. All rights reserved.
//

import UIKit
import CoreData

var state1: State?

final class SettingsViewController: UIViewController {
    
    //MARK: - Properties
    let ud = UserDefaults.standard
    var statesArray: [State] = []
    var label = UILabel(frame: CGRect(x: 0, y:0, width: 200, height: 22))
    var fetchedResultsController: NSFetchedResultsController<State>!
    
    //MARK: - IBOutlets
    @IBOutlet weak var tfDolar1: UITextField!
    @IBOutlet weak var tfIof1: UITextField!
    @IBOutlet weak var tvTax: UITableView!
    
    //MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tvTax.dataSource = self
        tvTax.delegate = self
        
        tfDolar1.delegate = self
        tfIof1.delegate = self
        
        tfDolar1.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.tapDone)), onCancel: (target: self, action: #selector(self.tapCancel)))
        
        tfIof1.addDoneCancelToolbar(onDone: (target: self, action: #selector(self.tapDone)), onCancel: (target: self, action: #selector(self.tapCancel)))
        
        loadState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tfDolar1.text = ud.string(forKey: UserDefaultKeys.dolar.rawValue)
        tfIof1.text = ud.string(forKey: UserDefaultKeys.iof.rawValue)
        
    }
        
    //MARK: - Methods
    func loadState() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            statesArray = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        try? fetchedResultsController.performFetch()
    }
    
    @objc func tapDone() {
        //print("tapped Done")
        
        tfDolar1.resignFirstResponder()
        tfIof1.resignFirstResponder()
        
        ud.set(tfDolar1.text!, forKey: UserDefaultKeys.dolar.rawValue)
        ud.set(tfIof1.text!, forKey: UserDefaultKeys.iof.rawValue)
    }
    
    @objc func tapCancel() {
        //print("tapped cancel")
        
        tfDolar1.resignFirstResponder()
        tfIof1.resignFirstResponder()
    }
    
    //MARK: - IBActions
    @IBAction func btAddEstado(_ sender: UIButton) {
        showInputDialog(
            title: "Adicionar Estado",
            actionTitle: "Adicionar",
            cancelTitle: "Cancelar",
            inputPlaceholder1: "Nome do estado",
            inputPlaceholder2:"Imposto",
            inputKeyboardType: .default,
            inputKeyboardType2: .decimalPad,
            actionHandler: { (input:String? ) in
                print("The new number is \(input ?? "")")
            }
        )
    }
    
}

extension SettingsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let state = fetchedResultsController.object(at: indexPath)
            context.delete(state)
            
            //Também apagar todos os produtos com o mesmo state
            //for product in state.products! {
            //context.delete(product as! NSManagedObject)
            //}
            
            try? context.save()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tvTax.cellForRow(at: indexPath) as? StateTableViewCell else {
            return
        }
        
        showInputDialog(
            title: "Editar Estado",
            actionTitle: "Salvar",
            cancelTitle: "Cancelar",
            inputPlaceholder1: cell.lbState.text ,
            inputPlaceholder2: cell.lbTax.text,
            inputKeyboardType: .default,
            inputKeyboardType2: .decimalPad
        )
    }
}


extension SettingsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StateTableViewCell else {
            return UITableViewCell()
        }
        
        let state = fetchedResultsController.object(at: indexPath)
        
        cell.prepare(with: state)
        
        return cell
    }
}

extension SettingsViewController: NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvTax.reloadData()
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        ud.set(tfDolar1.text!, forKey: UserDefaultKeys.dolar.rawValue)
        ud.set(tfIof1.text!, forKey: UserDefaultKeys.iof.rawValue)
        
        textField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func addDoneCancelToolbar(onDone: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onCancel = onCancel ?? (target: self, action: #selector(cancelButtonTapped))
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: onCancel.target, action: onCancel.action),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    @objc func doneButtonTapped() {
        self.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        self.resignFirstResponder()
    }
}
