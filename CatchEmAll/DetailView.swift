//
//  DetailView.swift
//  CatchEmAll
//
//  Created by Francesca MACDONALD on 2023-08-27.
//

import SwiftUI

struct DetailView: View {
    @StateObject var creatureDetailVM = CreaturesDetailViewModel()
    var creature: Creature
    
    var body: some View {
        VStack (alignment: .leading, spacing: 3) {
            Text(creature.name.capitalized)
                .font(Font.custom("Avenir Next Condensed", size: 60))
                .bold()
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.bottom)
            
            HStack {
                creatureIImage

                VStack (alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Height:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                        Text(String(format: "%.1f", creatureDetailVM.height))
                            .font(.largeTitle)
                            .bold()
                    }
                    HStack(alignment: .top) {
                        Text("Weight:")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.red)
                        Text(String(format: "%.1f", creatureDetailVM.weight))
                            .font(.largeTitle)
                            .bold()
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .task {
            creatureDetailVM.urlString = creature.url
            await creatureDetailVM.getData()
        }
    }
}

extension DetailView {
    var creatureIImage: some View {
        AsyncImage(url: URL(string: creatureDetailVM.imageURL)) { phase in
            if let image = phase.image { //we have a valid image
                let _ = print("VALID IMAGE ***") //this allows us to have a print statement in code that doesn't normally allow it!
                image
                    .resizable()
                    .scaledToFit()
                    .backgroundStyle(.white)
                    .frame(width: 96, height: 96)
                    .cornerRadius(16)
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
                    .padding(.trailing)
                
            } else if phase.error != nil { // we have an error
                let _ = print("!!! ERROR LOADING IMAGE !!")
                Image(systemName: "questionmark.app.dashed")
                    .resizable()
                    .scaledToFit()
                    .backgroundStyle(.white)
                    .frame(width: 96, height: 96)
                    .cornerRadius(16)
                    .shadow(radius: 8, x: 5, y: 5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray.opacity(0.5), lineWidth: 1)
                    }
                    .padding(.trailing)
                
            } else { //use a placeholder
                let _ = print("Placeholdder IMAGE !!")
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 96, height: 96)
                
            }
        }

    }
}
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(creature: Creature(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
    }
}
