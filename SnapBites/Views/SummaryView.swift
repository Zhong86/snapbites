import SwiftUI
import SwiftData

struct SummaryView: View {
    @Query var causes: [PossibleCauses]
    @State private var showAddSummary = false
    
    var body: some View {
        NavigationStack {
            List(causes) { cause in
                NavigationLink {
                    Text("test")
                } label: {
                    SummarySingle(data: cause)
                }
                .navigationLinkIndicatorVisibility(.hidden)
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddSummary = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSummary) {
                AddSummaryView()
            }
        }
    }
}

#Preview {
    SummaryView()
}
