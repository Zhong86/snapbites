import SwiftData
import Foundation

final class IngredientRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Create
    func create(name: String, timeUpdated: Date = Date.now) -> Ingredient {
        let ingredient = Ingredient(name: name, hasChecked: false, timeUpdated: timeUpdated)
        context.insert(ingredient)
        save()
        print("🟢 created:", ingredient.name, ingredient.timeUpdated, "id:", ingredient.id)
        let all = (try? context.fetch(FetchDescriptor<Ingredient>())) ?? []
        print("🟢 total ingredients in store right now:", all.count, all.map { ($0.name, $0.timeUpdated) })
        return ingredient
    }
    
    func createOrUpdate(name: String, timeUpdated: Date = Date.now) -> Ingredient {
        if let existing = fetch(byName: name) {
            existing.timeUpdated = timeUpdated
            save()
            return existing
        }
        return create(name: name, timeUpdated: timeUpdated)
    }
    
    // MARK: - Read
    func fetch(byName name: String) -> Ingredient? {
        let predicate = #Predicate<Ingredient> { $0.name == name }
        var descriptor = FetchDescriptor<Ingredient>(predicate: predicate)
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first
    }

    func fetchAll(on date: Date, calendar: Calendar = .current) -> [Ingredient] {
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else { return [] }
 
        let predicate = #Predicate<Ingredient> { ingredient in
            ingredient.timeUpdated >= start && ingredient.timeUpdated < end
        }
        let descriptor = FetchDescriptor<Ingredient>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timeUpdated)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func fetchWithPossibleCauses() -> [Ingredient] {
        let predicate = #Predicate<Ingredient> { ingredient in
            !ingredient.possibleCauses.isEmpty
        }
        let descriptor = FetchDescriptor<Ingredient>(predicate: predicate)
        return (try? context.fetch(descriptor)) ?? []
    }
    
    // MARK: - Update
    func update(_ ingredient: Ingredient, name: String? = nil, hasChecked: Bool? = nil) {
        if let name { ingredient.name = name }
        if let hasChecked { ingredient.hasChecked = hasChecked }
        ingredient.timeUpdated = Date()
        save()
    }
    
    func toggleChecked(_ ingredient: Ingredient) {
        ingredient.hasChecked.toggle()
        ingredient.timeUpdated = Date()
        save()
    }
    
    // MARK: - Delete
    func delete(_ ingredient: Ingredient) {
        context.delete(ingredient)
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
