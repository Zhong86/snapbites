//
//  Functions.swift
//  SnapBites
//
//  Created by Mac on 06/08/26.

import Foundation
import SwiftData

func getPossibleCauses(symptom: Symtomp, modelContext: ModelContext) throws -> (Bool, [Ingredient]) {
   
    var ingredients = Array<Ingredient>()
    var causes = Array<Ingredient>()
    
    do {
        // 1. get ingredient in 24h || has_checked = false
        ingredients = try getIngredients(modelContext: modelContext)
        print(ingredients)
        
        // 2. from ingredients get prev possiblecauses
        causes = try getPrevCauses(modelContext: modelContext, ingredients: ingredients)
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

func getPrevCauses(modelContext: ModelContext, ingredients: [Ingredient]) throws -> [Ingredient] {
    let ingredientNames = ingredients.map(\.name)
    
    let query = FetchDescriptor<PossibleCauses>(
        predicate: #Predicate { cause in
            if let causeIngredient = cause.ingredient {
                return ingredientNames.contains(causeIngredient.name) && cause.status == "cause";
            } else {
                return false;
            }
        }
    )
    
    var ingredients = Array<Ingredient>()
    do {
        let causes = try modelContext.fetch(query)
        for cause in causes {
            ingredients.append(cause.ingredient!)
        }
        
    } catch {
        print("Fetch failed:", error)
    }
    
    return ingredients
}
