import SwiftUI

struct SummarySingle: View {
    @Bindable var ingredient: Ingredient
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image(systemName: "bandage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(.black, lineWidth: 1)
                        )
                        .shadow(radius: 5)
                    
                    // Uses alignment to push text left, replacing the spaces hack
                    VStack(alignment: .leading, spacing: 4) {
                        
                        HStack{
                            Text(ingredient.name)
                                .font(.headline)
                                .bold()
                                .lineLimit(1)
                            Spacer()
                        }
                        
                        HStack{
                            Text("\(ingredient.possibleCauses.count) symptom(s)")
                                .padding(4)
                                .font(.caption)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(.black, lineWidth: 1)
                                )
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.leading, 8)
                    
                    Spacer()
                    VStack{
                        Text(ingredient.timeUpdated.formatted(.dateTime.month(.wide).day()))
                            .foregroundStyle(Color.blue)
                        Text(ingredient.timeUpdated.formatted(date: .omitted, time: .shortened))
                            .foregroundStyle(Color.blue)
                        Image(systemName: "chevron.right").fontWeight(.bold)
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.black, lineWidth: 1)
                )
                .shadow(radius: 5)
            }
            
        }
    }
}

#Preview {
    SummarySingle(ingredient: dummy)
}
