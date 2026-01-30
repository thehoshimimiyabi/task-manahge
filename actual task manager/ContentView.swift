//
//  ContentView.swift
//  Task 1
//
//  Created by Rayson Ng on 12/1/26.
//

import SwiftUI

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
}

struct TaskDetailView: View {
    @Binding var task: TaskItem

    var body: some View {
        VStack(spacing: 20) {
            Text(task.title)
                .font(.title)
                .padding(.top)

            Text(task.isDone ? "Status: ✅ Finished" : "Status: ❌ Not finished")
                .font(.headline)
                .foregroundStyle(task.isDone ? .green : .red)

            HStack(spacing: 16) {
                Button {
                    task.isDone = true
                } label: {
                    Text("Yes, finished ✅")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                Button {
                    task.isDone = false
                } label: {
                    Text("No, not yet ❌")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Task")
    }
}

struct ContentView: View {
    @State var tasks: [TaskItem] = [
        TaskItem(title: "Play HSR"),
        TaskItem(title: "Pack desk")
    ]
    @State var importantTasks: [TaskItem] = [
        TaskItem(title: "homework"),
        TaskItem(title: "Buy groceries"),
        TaskItem(title: "do ict")
    ]

    var body: some View {
        NavigationStack {
            List {
                Section("Important Tasks") {
                    ForEach($importantTasks) { $item in
                        NavigationLink(destination: TaskDetailView(task: $item)) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(item.isDone ? "✅" : "❌")
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .foregroundStyle(.red)
                                    Text("VERY IMPORTANT!!")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                Section("Tasks") {
                    ForEach($tasks) { $item in
                        NavigationLink(destination: TaskDetailView(task: $item)) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(item.isDone ? "✅" : "❌")
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.title)
                                        .foregroundStyle(.blue)
                                    Text("Tasks")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
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
