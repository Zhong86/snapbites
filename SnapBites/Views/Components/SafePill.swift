import SwiftUI

struct SafePill: View {
    var body: some View {
        Label("Safe", systemImage: "checkmark.seal.fill")
            .padding(4)
            .font(.caption)
            .foregroundStyle(.white)
            .background(.green)
            .clipShape(RoundedRectangle(cornerRadius: 50))
            .shadow(radius: 5)
    }
}

#Preview {
    SafePill()
}
