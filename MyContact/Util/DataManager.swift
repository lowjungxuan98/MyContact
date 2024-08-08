//
//  DataManager.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation

struct Person: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String?
    let dob: String?
    var nameShortForm: String {
        let firstInitial = firstName.first?.uppercased() ?? ""
        let lastInitial = lastName.first?.uppercased() ?? ""
        return firstInitial + lastInitial
    }
}

class DataManager {
    
    static let shared = DataManager()
    
    private let fileName = "data.json"
    
    private init() {
        copyFileToDocumentsDirectoryIfNeeded()
    }
    
    private var fileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    private func copyFileToDocumentsDirectoryIfNeeded() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: fileURL.path) {
            if let bundleURL = Bundle.main.url(forResource: fileName, withExtension: nil) {
                do {
                    try fileManager.copyItem(at: bundleURL, to: fileURL)
                } catch {
                    print("Error copying file to documents directory: \(error)")
                }
            }
        }
    }
    
    func readData() -> [String: [Person]]? {
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard var persons = try? decoder.decode([Person].self, from: data) else {
            return nil
        }
        persons.sort { $0.firstName < $1.firstName }
        persons.forEach { p in
            print(p)
        }
        let groupedPersons = Dictionary(grouping: persons) { $0.firstName.first.map { String($0) } ?? "#" }
        return groupedPersons
    }
    
    func saveData(_ persons: [Person]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(persons) else {
            return
        }
        try? data.write(to: fileURL)
    }
    
    func addPerson(_ person: Person) {
        var persons = readAllPersons()
        persons.append(person)
        saveData(persons)
    }
    
    func updatePerson(_ updatedPerson: Person) {
        var persons = readAllPersons()
        if let index = persons.firstIndex(where: { $0.id == updatedPerson.id }) {
            persons[index] = updatedPerson
            saveData(persons)
        }
    }
    
    func deletePerson(byId id: String) {
        var persons = readAllPersons()
        persons.removeAll { $0.id == id }
        saveData(persons)
    }
    
    func getPerson(byId id: String) -> Person? {
        let persons = readAllPersons()
        return persons.first { $0.id == id }
    }
    
    private func readAllPersons() -> [Person] {
        guard let groupedPersons = readData() else {
            return []
        }
        return groupedPersons.flatMap { $0.value }
    }
    
    func searchPersons(with query: String) -> [String: [Person]] {
        let allPersons = readAllPersons()
        let filteredPersons = allPersons.filter { person in
            person.firstName.lowercased().contains(query.lowercased()) ||
            person.lastName.lowercased().contains(query.lowercased())
        }
        let groupedPersons = Dictionary(grouping: filteredPersons) { $0.firstName.first.map { String($0) } ?? "#" }
        return groupedPersons
    }
}
