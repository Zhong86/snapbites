import SwiftData
import Foundation

final class IngredientRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Create
<<<<<<< HEAD
    func create(name: String, timeUpdated: Date = Date.now) -> Ingredient {
        let ingredient = Ingredient(name: name, hasChecked: false, timeUpdated: timeUpdated)
=======
    func create(name: String, hasChecked: Bool = false) -> Ingredient {
        let ingredient = Ingredient(name: name, hasChecked: hasChecked)
>>>>>>> ec447a198887c9e619f6dbb0e1b85bbab5c59caf
        context.insert(ingredient)
        save()
        return ingredient
    }
    
    // MARK: - Read
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
