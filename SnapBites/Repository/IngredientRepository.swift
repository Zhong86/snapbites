import SwiftData
import Foundation

final class IngredientRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Create
    @discardableResult
    func create(name: String, hasChecked: Bool = false) -> Ingredient {
        let ingredient = Ingredient(name: name, hasChecked: hasChecked)
        context.insert(ingredient)
        save()
        return ingredient
    }
    
    // MARK: - Read
    func fetchAll(sortBy: SortDescriptor<Ingredient> = SortDescriptor(\.name)) -> [Ingredient] {
        let descriptor = FetchDescriptor<Ingredient>(sortBy: [sortBy])
        return (try? context.fetch(descriptor)) ?? []
    }
    
    func fetch(byName name: String) -> Ingredient? {
        let predicate = #Predicate<Ingredient> { $0.name == name }
        var descriptor = FetchDescriptor<Ingredient>(predicate: predicate)
        descriptor.fetchLimit = 1
        return (try? context.fetch(descriptor))?.first
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
    
    func deleteAll() {
        let all = fetchAll()
        all.forEach { context.delete($0) }
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
