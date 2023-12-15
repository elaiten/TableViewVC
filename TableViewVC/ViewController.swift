//
//  ViewController.swift
//  TableViewVC
//
//  Created by Руслан on 13.12.2023.
//

import UIKit


class ViewController: UIViewController  {
    
    var storage: ContactStorageProtocol!
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func showNewContactAlert() {
        let alertController = UIAlertController(title: "Введите имя", message: "Введите имя и телефон", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Номер"
           
            
        }
        let createButton = UIAlertAction(title: "Создать", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text, let contactPhone = alertController.textFields?[1].text else {return}
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contact.append(contact)
            
            self.tableView.reloadData()
        }
        let cancelButon = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelButon)
        alertController.addAction(createButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
     var contact: [ContactProtocol] = [] {
        didSet {
            contact.sort { $0.title < $1.title }
            guard let newStorage = storage else {return}
            newStorage.save(contacts: contact)
        }
    }
    
    
    private func loadContacts() {
        contact = storage.load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
    }
    
    
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            self.contact.remove(at: indexPath.row)
            tableView.reloadData()
        }
        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            
            cell = reuseCell
        } else {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    private func configure( cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = contact[indexPath.row].title
        configuration.secondaryText = contact[indexPath.row].phone
        cell.contentConfiguration = configuration
    }
    
}
