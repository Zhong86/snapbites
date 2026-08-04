import SwiftUI

struct LogView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "globe").padding(12).background(Color.blue)
                VStack {
                    HStack {
                        Text("Log")
                        Spacer()
                        Text("2023-12-12")
                    }
                    HStack {
                        Text("Description")
                        Spacer()
                    }
                }
            }.padding(12).background(Color.green)
        }
    }
}

#Preview {
    LogView()
}
