//
//  ContentView.swift
//  letsVote!
//
//  Created by Cyber Slayer on 28/8/23.
//

import SwiftUI

struct Candidate: Identifiable, Comparable {
    static func < (lhs: Candidate, rhs: Candidate) -> Bool {
        lhs.votes > rhs.votes
    }
    
    let id = UUID()
    var name: String
    var description: String
    var votes: Int
}

@main
struct VotingApp: App {
    @State private var candidates: [Candidate] = [
        Candidate(name: "Jonny Appleseed", description: "I love eating apples yayyyyy", votes: 0),
        Candidate(name: "Christan Tan", description: "I love Cheese :)", votes: 0)
    ]
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CandidatesListTab(candidates: $candidates)
                    .tabItem {
                        Label("Candidate List", systemImage: "list.dash")
                    }
                
                Spacer()
                
                VoteTab(candidates: $candidates)
                    .tabItem {
                        Label("Vote", systemImage: "checkmark.circle")
                    }
            }
        }
    }
}

struct CandidatesListTab: View {
    @Binding var candidates: [Candidate]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(candidates) { candidate in
                    NavigationLink(destination: CandidateDetail(candidate: candidate)) {
                        VStack(alignment: .leading) {
                            Text(candidate.name)
                                .font(.headline)
                            Text(candidate.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Candidates")
            .foregroundColor(.mint)
            .navigationBarItems(leading: EditButton(), trailing:
                                    NavigationLink("Add Candidate", destination: AddCandidateView(candidates: $candidates))
            )
        }
    }
    
    private func delete(at offsets: IndexSet) {
        candidates.remove(atOffsets: offsets)
    }
}

struct AddCandidateView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var candidates: [Candidate]
    
    @State private var candidateName = ""
    @State private var candidateDescription = ""
    
    var body: some View {
        Form {
            Section(header: Text("New Candidate")) {
                TextField("Name", text: $candidateName)
                TextField("Description", text: $candidateDescription)
            }
            
            Button("Add Candidate") {
                candidates.append(Candidate(name: candidateName, description: candidateDescription, votes: 0))
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitle("ADD CANDIDATE")
        .foregroundColor(.blue)
    }
}

struct CandidateDetail: View {
    let candidate: Candidate
    
    var body: some View {
        VStack {
            Text(candidate.name)
                .font(.title)
                .padding()
            Text(candidate.description)
                .padding()
        }
        .navigationTitle("Candidate Detail")
        .foregroundColor(.white)
    }
}

struct VoteTab: View {
    @Binding var candidates: [Candidate]
    
    var body: some View {
        List {
            ForEach(candidates) { candidate in
                HStack {
                    Text(candidate.name)
                        .font(.headline)
                    Spacer()
                    Stepper(
                        value: Binding<Int>(
                            get: { candidate.votes },
                            set: { newValue in
                                let updatedValue = min(max(newValue, 0), Int.max - 1)
                                updateVotes(for: candidate, newValue: updatedValue)
                            }
                        ),
                        in: 0...Int.max - 1
                    ) {
                        Text("\(candidate.votes)")
                    }
                    HStack(spacing: 8) {
                        Button(action: {
                            vote(for: candidate, value: 1)
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                        Button(action: {
                            vote(for: candidate, value: -1)
                        }) {
                            Image(systemName: "minus.circle.fill")
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationTitle("Vote")
    }
    
    private func updateVotes(for candidate: Candidate, newValue: Int) {
        if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
            candidates[index].votes = newValue
            candidates.sort()
        }
    }
    
    private func vote(for candidate: Candidate, value: Int) {
        if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
            candidates[index].votes += value
            candidates.sort()
        }
    }
}


