//
//  ContentView.swift
//  Task 1
//
//  Created by Rayson Ng on 12/1/26.
//

import SwiftUI

struct ContentView: View {
    @State var tasks: [String] = ["Play HSR", "Pack desk"]
    @State var importantTasks: [String] = ["homework", "Buy groceries", "do ict"]

    var body: some View {
        NavigationStack {
            List {                   
                Section("Important Tasks") {
                    ForEach(importantTasks, id: \.self) { item in
                        NavigationLink(destination: Text(item).padding()) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item)
                                    .foregroundStyle(.red)
                                Text("VERY IMPORTANT!!")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                Section("Tasks") {
                    ForEach(tasks, id: \.self) { item in
                        NavigationLink(destination: Text(item).padding()) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item)
                                    .foregroundStyle(.blue)
                                Text("Tasks")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Tasks")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
