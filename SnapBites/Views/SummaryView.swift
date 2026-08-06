import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query var symptoms: [PossibleCauses]
    var body: some View {
        NavigationStack {
            List(symptoms, id: \.self) {symptom in
                NavigationLink{
                    Text("test")
                } label: {
                    SummarySingle(data: symptom)
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
