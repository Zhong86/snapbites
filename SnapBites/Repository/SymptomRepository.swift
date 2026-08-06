import SwiftData
import Foundation

final class SymptomRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Create
    func create(name: String, imageName: String) -> Symtomp {
        let symptom = Symtomp(name: name, imageName: imageName)
        context.insert(symptom)
        save()
        return symptom
    }
    
    // MARK: - Read
    func fetchAll(sortBy: SortDescriptor<Symtomp> = SortDescriptor(\.name)) -> [Symtomp] {
        let descriptor = FetchDescriptor<Symtomp>(sortBy: [sortBy])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func fetch(byName name: String) -> Symtomp? {
        let predicate = #Predicate<Symtomp> { $0.name == name }
        var descriptor = FetchDescriptor<Symtomp>(predicate: predicate)
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first
    }
    
    // MARK: - Update
    func update(_ symptom: Symtomp, name: String? = nil, imageName: String? = nil) {
        if let name { symptom.name = name }
        if let imageName { symptom.imageName = imageName }
        symptom.lastChecked = Date()
        save()
    }
    
    func touch(_ symptom: Symtomp) {
        symptom.lastChecked = Date()
        save()
    }
    
    // MARK: - Delete
    func delete(_ symptom: Symtomp) {
        context.delete(symptom)
        save()
    }
    
    func deleteAll() {
        fetchAll().forEach { context.delete($0) }
        save()
    }
    
    // MARK: - Helper
    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

