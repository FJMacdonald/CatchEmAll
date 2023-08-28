//
//  CreaturesListView.swift
//  CatchEmAll
//
//  Created by Francesca MACDONALD on 2023-08-27.
//
//https://pokeapi.co/api/v2/pokemon/

import SwiftUI

struct CreaturesListView: View {
    var creatures = ["Pikachu", "Squirtle", "Charzard", "Snorlax"
    ]
    @StateObject var creaturesVM = CreaturesViewModel()
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                List(searchResults) { creature in
                    LazyVStack {
                        NavigationLink {
                            DetailView(creature: creature)
                        } label: {
                            Text(" \(creature.name.capitalized)")
                                .font(.title2)
                        }
                    }
                    .onAppear {
                        creaturesVM.loadNextIfNeeded(creature: creature)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Pokemon")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        Button("Load All") {
                            Task {
                                await creaturesVM.loadAll()
                            }
                        }
                    }
                    ToolbarItem(placement: .status) {
                        Text("\(creaturesVM.creaturesArray.count) of \(creaturesVM.count)")
                    }
                }
                .searchable(text: $searchText)
                if creaturesVM.isLoading {
                    ProgressView()
                        .tint(.red)
                        .scaleEffect(4)
                }
            }
            .task {
                await creaturesVM.getData()
            }
        }
    }
    var searchResults: [Creature] {
        if searchText.isEmpty {
            return creaturesVM.creaturesArray
        } else {
            return creaturesVM.creaturesArray.filter { $0.name.capitalized.contains(searchText)}
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CreaturesListView()
    }
}
