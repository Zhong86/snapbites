import SwiftUI

struct StickyAddLogButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .foregroundColor(.white)
                .padding(14)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    StickyAddLogButton(action: {})
        .padding()
        .background(Color(.systemGray6))
}
