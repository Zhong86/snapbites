//
//  Functions.swift
//  SnapBites
//
//  Created by Mac on 06/08/26.

import Foundation
import SwiftData

class SymptomCheckService {
    
    func newSymptom(symptom: Symtomp, modelContext: ModelContext) -> (Bool, [Ingredient]) {
        var pc: (Bool, [Ingredient]) = (false, [])
        do {
            pc = try getPossibleCauses(symptom: symptom, modelContext: modelContext)
 
            if pc.0 {
                // Cause already known — caller shows an alert, nothing to create.
            } else {
                // No known cause yet — create a PossibleCauses entry per candidate ingredient.
                let causesRepository = PossibleCausesRepository(context: modelContext)
                for ingredient in pc.1 {
                    _ = causesRepository.fetchOrCreate(ingredient: ingredient, symptom: symptom)
                }
            }
        } catch {
            print("Fail to find possible causes.")
        }
        
        print(pc)
        return pc
    }

    
    func getPossibleCauses(symptom: Symtomp, modelContext: ModelContext) throws -> (Bool, [Ingredient]) {
        
        var ingredients = Array<Ingredient>()
        var causes = Array<Ingredient>()
        
        do {
            // 1. get ingredient in 24h || has_checked = false
            ingredients = try getIngredients(modelContext: modelContext)
            print(ingredients)
            
            // 2. from ingredients get prev possiblecauses
            causes = try getPrevCauses(modelContext: modelContext, ingredients: ingredients, symptom: symptom)
        } catch {
            print("Fetch failed:", error)
        }
        
        if causes.count > 0 {
            return (true, causes);
        }
        else {
            return (false, ingredients);
        }
    }
    
    func getIngredients(modelContext: ModelContext) throws -> [Ingredient]{
        let cutoff = Calendar.current.date(byAdding: .hour, value: -24, to: Date())!
        
        let ingredientQuery = FetchDescriptor<Ingredient>(
            predicate: #Predicate { ingredient in
                ingredient.timeUpdated >= cutoff
                || ingredient.hasChecked == false
            }
        )
        
        return try modelContext.fetch(ingredientQuery)
    }
    
    func getPrevCauses(modelContext: ModelContext, ingredients: [Ingredient], symptom: Symtomp) throws -> [Ingredient] {
        let ingredientNames = ingredients.map(\.name)
        
        let query = FetchDescriptor<PossibleCauses>(
            predicate: #Predicate { cause in
                cause.status == "cause"
            }
        )

        var ingredients = Array<Ingredient>()
        do {
            let causes = try modelContext.fetch(query)
            for cause in causes {
                guard cause.symptom?.persistentModelID == symptom.persistentModelID else { continue }
                if let causeIngredient = cause.ingredient, ingredientNames.contains(causeIngredient.name) {
                    ingredients.append(causeIngredient)
                }
            }
            
        } catch {
            print("Fetch failed:", error)
        }
        
        return ingredients
    }
}
