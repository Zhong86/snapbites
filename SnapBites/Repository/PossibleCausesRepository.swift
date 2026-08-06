import SwiftData
import Foundation

final class PossibleCausesRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Create
    func create(
        ingredient: Ingredient? = nil,
        symptom: Symtomp? = nil,
        status: String = "unchecked"
    ) -> PossibleCauses {
        let cause = PossibleCauses(ingredient: ingredient, symptom: symptom, status: status)
        context.insert(cause)
        save()
        return cause
    }
    
    // MARK: - Read
    func fetchAll(sortBy: SortDescriptor<PossibleCauses> = SortDescriptor(\.lastUpdated, order: .reverse)) -> [PossibleCauses] {
        let descriptor = FetchDescriptor<PossibleCauses>(sortBy: [sortBy])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func fetch(byStatus status: String) -> [PossibleCauses] {
        let predicate = #Predicate<PossibleCauses> { $0.status == status }
        let descriptor = FetchDescriptor<PossibleCauses>(predicate: predicate)
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func fetch(for ingredient: Ingredient) -> [PossibleCauses] {
        ingredient.possibleCauses
    }
    
    func fetch(for symptom: Symtomp) -> [PossibleCauses] {
        symptom.possibleCauses
    }
    
    func fetchOrCreate(ingredient: Ingredient, symptom: Symtomp) -> PossibleCauses {
        if let existing = ingredient.possibleCauses.first(where: { $0.symptom === symptom }) {
            return existing
        }
        return create(ingredient: ingredient, symptom: symptom)
    }
    
    // MARK: - Update
    func update(_ cause: PossibleCauses, status: String) {
        cause.status = status
        cause.lastUpdated = Date()
        save()
    }
    
    func markAsCause(_ cause: PossibleCauses) {
        update(cause, status: "cause")
    }
    
    func markAsNonCause(_ cause: PossibleCauses) {
        update(cause, status: "non_cause")
    }
    
    func reset(_ cause: PossibleCauses) {
        update(cause, status: "unchecked")
    }
    
    // MARK: - Delete
    func delete(_ cause: PossibleCauses) {
        context.delete(cause)
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
