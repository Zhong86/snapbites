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
    func fetchAll(on date: Date, calendar: Calendar = .current) -> [Symtomp] {
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return [] }
 
        let predicate = #Predicate<Symtomp> { symptom in
            symptom.lastChecked >= start && symptom.lastChecked < end
        }
        let descriptor = FetchDescriptor<Symtomp>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.lastChecked)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    
    func fetch(byName name: String) -> Symtomp? {
        let predicate = #Predicate<Symtomp> { $0.name == name }
        var descriptor = FetchDescriptor<Symtomp>(predicate: predicate)
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first
    }
    
    // MARK: - Update
    func updateDate(_ symptom: Symtomp, date: Date) -> Symtomp {
        symptom.lastChecked = date
        save()
        return symptom
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
    
    // MARK: - Helper
    private func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}

