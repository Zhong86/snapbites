import SwiftUI
struct SummaryView: View {
    var syntoms: [PossibleCauses] = [
        PossibleCauses(id:"1", ingredientId: "nasi padang", symtompId: "batuk", status: "unchecked", lastUpdated: Date.now),
        PossibleCauses(id:"2", ingredientId: "nasi goreng", symtompId:"panas", status: "unchecked", lastUpdated: Date.now), PossibleCauses(id:"3", ingredientId: "nasi ayam", symtompId:"gatal", status: "unchecked", lastUpdated: Date.now),PossibleCauses(id:"3", ingredientId: "nasi geprek", symtompId:"panas", status: "unchecked", lastUpdated: Date.now),PossibleCauses(id:"2", ingredientId: "nasi ikan", symtompId:"panas", status: "unchecked", lastUpdated: Date.now),PossibleCauses(id:"2", ingredientId: "nasi cumi", symtompId:"panas", status: "unchecked", lastUpdated: Date.now),PossibleCauses(id:"2", ingredientId: "nasi matang", symtompId:"panas", status: "unchecked", lastUpdated: Date.now),
    ]
    
    
    
    var body: some View {
        NavigationStack {
            List(syntoms, id: \.self) {syntom in
                NavigationLink{
                    Text("test")
                } label: {
                    SummarySingle(data: syntom)
                }
                .navigationLinkIndicatorVisibility(.hidden)
                    .listRowSeparator(.hidden)
                
            }.listStyle(.plain)
                
        }
    }
}

#Preview {
    SummaryView()
}
