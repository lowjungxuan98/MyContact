//
//  LocalStorage.swift
//  MyContact
//
//  Created by Low Jung Xuan on 08/08/2024.
//

import Foundation
import CoreData

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyAppModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


class LocalStorage {

    static let shared = LocalStorage()

    private init() {}

    func createEntity(id: String) {
        let context = CoreDataStack.shared.context
        let entity = Entity(context: context)
        entity.id = id
        saveContext()
    }

    func fetchEntities() -> [Entity] {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        } catch {
            print("Error fetching entities: \(error)")
            return []
        }
    }

    func updateEntity(id: String, newId: String) {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let entities = try context.fetch(fetchRequest)
            if let entityToUpdate = entities.first {
                entityToUpdate.id = newId
                saveContext()
            }
        } catch {
            print("Error updating entity: \(error)")
        }
    }

    func deleteEntity(id: String) {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let entities = try context.fetch(fetchRequest)
            if let entityToDelete = entities.first {
                context.delete(entityToDelete)
                saveContext()
            }
        } catch {
            print("Error deleting entity: \(error)")
        }
    }

    private func saveContext() {
        CoreDataStack.shared.saveContext()
    }
}
