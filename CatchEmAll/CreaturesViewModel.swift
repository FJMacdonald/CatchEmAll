//
//  CreaturesViewModel.swift
//  CatchEmAll
//
//  Created by Francesca MACDONALD on 2023-08-27.
//

import Foundation


// Add @MainActor to SwiftUI classes that Publish values or work with the user interface.  This removes warning "Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates."
@MainActor
class CreaturesViewModel: ObservableObject {
    
    private struct Returned: Codable {
        var count: Int
        var next: String?
        var results: [Creature]
    }
    
    
    @Published var urlString = "https://pokeapi.co/api/v2/pokemon"
    @Published var count = 0
    @Published var creaturesArray: [Creature] = []
    @Published var isLoading = false
    
    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        isLoading = true
        
        // convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Try to decode JSON data into our data structure
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not deccode returned JSON data")
                isLoading = false
                return
            }
            self.count = returned.count
            self.urlString = returned.next ?? ""
            self.creaturesArray =  self.creaturesArray + returned.results
            isLoading = false
        } catch {
            isLoading = false
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
    
    func loadNextIfNeeded(creature: Creature) {
        guard let lastCreature = creaturesArray.last else { return}
        if creature.id == lastCreature.id && urlString.hasPrefix("http") {
            Task {
                await getData ()
            }
        }
    }
    
    
    func loadAll() async {
        guard urlString.hasPrefix("http") else {return}
        await getData() // get next page off data
        await loadAll() // call loadAll again (will stop once all pages have been retrieved)
    }
    
}
