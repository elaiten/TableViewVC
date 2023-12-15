//
//  Contact.swift
//  TableViewVC
//
//  Created by Руслан on 13.12.2023.
//

import Foundation

protocol ContactProtocol {
    
    var title: String {get set}
    var phone: String {get set}
}

struct Contact: ContactProtocol {
    var title: String
    var phone: String
}


protocol ContactStorageProtocol {
    func load() -> [ContactProtocol]
    func save(contacts: [ContactProtocol])
}

class ContactStorage: ContactStorageProtocol {
    // Ссылка на хранилище
    private var storage = UserDefaults.standard
    // Ключ, по которому будет происходить сохранение хранилища
    private var storageKey = "contacts"
    // Перечисление с ключами для записи в User Defaultsa
    private enum ContactKey: String {
        case title
        case phone
    }
    
    
    
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String: String]] ?? []
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                    let phone = contact[ContactKey.phone.rawValue] else {continue}
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String: String]] = []
        contacts.forEach { contacts in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contacts.title
            newElementForStorage[ContactKey.phone.rawValue] = contacts.phone
            arrayForStorage.append(newElementForStorage)
        }
        print(arrayForStorage)
        storage.set(arrayForStorage, forKey: storageKey)
    }
    
    
}

