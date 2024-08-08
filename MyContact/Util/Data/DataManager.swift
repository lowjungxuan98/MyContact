//
//  DataManager.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation

struct Person: Codable {
    var id: String?
    var firstName: String
    var lastName: String
    var email: String?
    var dob: String?
    var nameShortForm: String {
        let firstInitial = firstName.first?.uppercased() ?? ""
        let lastInitial = lastName.first?.uppercased() ?? ""
        return firstInitial + lastInitial
    }
    
    mutating func updateFirstName(_ t: String?) {
        firstName = t ?? ""
    }
    
    mutating func updateLastName(_ t: String?) {
        lastName = t ?? ""
    }
    
    mutating func updateEmail(_ t: String?) {
        email = t
    }
    
    mutating func updateDob(_ t: String?) {
        dob = t
    }
    
    mutating func generateRandomHexadecimalID(length: Int = 24) {
        let characters = "0123456789abcdef"
        var result = ""
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            result.append(randomCharacter)
        }
        id = result
    }
}

class DataManager {
    
    static let shared = DataManager()
    
    private let fileName = "data.json"
    private let originalFileName = "original.json"
    
    private init() {
        copyFileToDocumentsDirectoryIfNeeded()
    }
    
    private var fileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(fileName)
    }
    
    private var originalFileURL: URL {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent(originalFileName)
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
        var person = person
        person.generateRandomHexadecimalID()
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
    
    func generateRandomHexadecimalID(length: Int = 24) -> String {
        let characters = "0123456789abcdef"
        var result = ""
        for _ in 0..<length {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            result.append(randomCharacter)
        }
        return result
    }
    
    func resetData() {
        let fileManager = FileManager.default
        do {
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
            if let bundleURL = Bundle.main.url(forResource: originalFileName, withExtension: nil) {
                try fileManager.copyItem(at: bundleURL, to: fileURL)
            } else if fileManager.fileExists(atPath: originalFileURL.path) {
                try fileManager.copyItem(at: originalFileURL, to: fileURL)
            } else {
                print("Original file not found in bundle or documents directory.")
            }
        } catch {
            print("Error resetting data: \(error)")
        }
    }
}
