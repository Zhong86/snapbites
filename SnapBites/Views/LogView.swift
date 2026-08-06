import SwiftUI
import SwiftData
import EventKit
import Observation

struct LogView: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    HStack {
                        Spacer()
                    }
                }.padding(12)
                    
                
                VStack{
                    HStack(spacing: 10){
                        Spacer() .frame(width: 1)
                        HStack{
                            Text("1")
                            Image(systemName: "flame.fill").foregroundColor(.red)
                        }
                        Spacer() .frame(width: 15)
                        
                        Text("Sun")
                        Text("Mon")
                        Text("Tue")
                        Text("Wed")
                        Text("Thu")
                        Text("Fri")
                        Text("Sat")
                        Spacer() .frame(width: 15)
                    }
                    HStack (spacing:18){
                        Text("weeks")
                            .padding(.trailing)
                        HStack( spacing: 18 ){
                            Text("29")
                            Text("30")
                            Text("31")
                            Text("01")
                            Text("02")
                            Text("03")
                            Text("04")
                                .padding(.trailing, 26)
                        }
                    }
                } .background(.white) .clipShape(Capsule()) .padding(.top,20) .shadow(color: .black, radius: 1, y:5)
                Spacer()
                }
        } .background(.green)
        }
    }

#Preview {
    LogView()
}
