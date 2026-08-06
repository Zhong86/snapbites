//
//  JournalService.swift
//  SnapBites
//
//  Created by Mac on 06/08/26.
//

import Foundation
import SwiftData


final class JournalService {
    
    let ingredientRepository: IngredientRepository;
    let symptomRepository: SymptomRepository;
    
    init(ingredientRepository: IngredientRepository, symptomRepository: SymptomRepository) {
        self.ingredientRepository = ingredientRepository
        self.symptomRepository = symptomRepository
    }
    
    func getJournal(date: Date, calendar: Calendar = .current) -> [JournalEntry] {
        let ingredients = ingredientRepository.fetchAll(on: date, calendar: calendar)
        let symptoms = symptomRepository.fetchAll(on: date, calendar: calendar)
 
        let ingredientEntries = ingredients.map { ingredient in
            JournalEntry(
                time: ingredient.timeUpdated.formatted(date: .omitted, time: .shortened),
                title: "Food",
                subtitle: ingredient.name,
                isSymptom: false,
                hour: calendar.component(.hour, from: ingredient.timeUpdated)
            )
        }
 
        let symptomEntries = symptoms.map { symptom in
            JournalEntry(
                time: symptom.lastChecked.formatted(date: .omitted, time: .shortened),
                title: symptom.name,
                subtitle: "",
                isSymptom: true,
                hour: calendar.component(.hour, from: symptom.lastChecked)
            )
        }
 
        return (ingredientEntries + symptomEntries).sorted { $0.hour < $1.hour }
    }
}
