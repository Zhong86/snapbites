//
//  Functions.swift
//  SnapBites
//
//  Created by Mac on 06/08/26.

import Foundation
import SwiftData

class SymptomCheckService {
    
    func newSymptom(symptom: Symtomp, modelContext: ModelContext) {
        var pc: (Bool, [Ingredient]) = (false, [])
        do {
            pc = try getPossibleCauses(symptom: symptom, modelContext: modelContext)
            // check if true, if yes return the cause and alert
            if pc.0 == true {
                // You have the ingredients in pc.1 to return or alert with
                print("Found causes: \(pc.1)")
            }
            // if false then create possiblecause for each ingredient
            else {
                // Loop through pc.1 to create your possible causes
                for ingredient in pc.1 {
                    print("Creating possible cause for: \(ingredient)")
                }
            }
        } catch {
            print("Fail to find possible causes.")
        }
        
    }
    
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
}
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
