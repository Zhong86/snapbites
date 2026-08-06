import SwiftUI
import SwiftData
import EventKit
import Observation

struct LogView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showModal = false
    var body: some View {
        VStack{
            Button(action: {
                showModal.toggle()
            }) {
                HStack {
                    Spacer ()
                    Image(systemName: "plus.circle")
                    
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.blue)
                        .frame(width: 40, height: 50)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.white)
                        .cornerRadius(50)
                    
                }
            }
            .sheet(isPresented: $showModal) {
                CreateLogView()
            }
            Spacer ()
        }
    }
}
#Preview {
    LogView()
}
