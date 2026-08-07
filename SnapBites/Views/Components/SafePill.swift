import SwiftUI

struct SafePill: View {
    var body: some View {
        Label("Safe", systemImage: "checkmark.seal.fill")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule().fill(Color.primaryGreen)
            )
            .shadow(color: Color.primaryGreen.opacity(0.25), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    SafePill()
        .padding()
        .background(Color.appBackground)
}
