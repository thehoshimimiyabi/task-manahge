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
    var isImportant: Bool = false
    var dueDate: Date? = nil
    
    var formattedDueDate: String {
        guard let dueDate else { return "No due date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dueDate)
    }
}

struct TaskDetailView: View {
    @Binding var task: TaskItem

    var body: some View {
        VStack(spacing: 20) {
            TextField("Title", text: $task.title)
                .textFieldStyle(.roundedBorder)
                .font(.title2)
                .padding(.top)

            Text(task.isDone ? "Status: ✅ Finished" : "Status: ❌ Not finished")
                .font(.headline)
                .foregroundStyle(task.isDone ? .green : .red)
            
            Toggle(isOn: $task.isImportant) {
                Label("Mark as Important", systemImage: task.isImportant ? "star.fill" : "star")
            }
            .toggleStyle(.switch)
            .padding(.horizontal)

            Divider()

            HStack(alignment: .firstTextBaseline) {
                Text("Due:")
                    .font(.headline)
                if let due = task.dueDate {
                    DatePicker("", selection: Binding(get: { due }, set: { task.dueDate = $0 }), displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                    Button("Clear") { task.dueDate = nil }
                        .buttonStyle(.borderless)
                } else {
                    DatePicker("", selection: Binding(get: { Date() }, set: { task.dueDate = $0 }), displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                }
            }
            .textCase(nil)

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
        TaskItem(title: "homework", isDone: false, isImportant: true, dueDate: nil),
        TaskItem(title: "Buy groceries", isDone: false, isImportant: true, dueDate: nil),
        TaskItem(title: "do ict", isDone: false, isImportant: true, dueDate: nil),
        TaskItem(title: "Play HSR", isDone: false, isImportant: false, dueDate: nil),
        TaskItem(title: "Pack desk", isDone: false, isImportant: false, dueDate: nil)
    ]
    
    @State private var showingAddSheet = false
    @State private var newTitle = ""
    @State private var newIsImportant = false
    @State private var newDueDate: Date? = nil
    @State private var useDueDate = false

    var body: some View {
        NavigationStack {
            List {
                Section("Important Tasks") {
                    ForEach($tasks.indices.filter { tasks[$0].isImportant }, id: \.self) { index in
                        let binding = $tasks[index]
                        NavigationLink(destination: TaskDetailView(task: binding)) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(binding.wrappedValue.isDone ? "✅" : "❌")
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(binding.wrappedValue.title)
                                            .foregroundStyle(.red)
                                        Image(systemName: "star.fill").foregroundStyle(.yellow)
                                    }
                                    Text("Due: \(binding.wrappedValue.formattedDueDate)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete { offsets in
                        let importantIndices = tasks.indices.filter { tasks[$0].isImportant }
                        let toDelete = IndexSet(offsets.compactMap { importantIndices[$0] })
                        tasks.remove(atOffsets: toDelete)
                    }
                }
                Section("Lower Priority Tasks") {
                    ForEach($tasks.indices.filter { !tasks[$0].isImportant }, id: \.self) { index in
                        let binding = $tasks[index]
                        NavigationLink(destination: TaskDetailView(task: binding)) {
                            HStack(alignment: .firstTextBaseline, spacing: 8) {
                                Text(binding.wrappedValue.isDone ? "✅" : "❌")
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(binding.wrappedValue.title)
                                        .foregroundStyle(.blue)
                                    Text("Due: \(binding.wrappedValue.formattedDueDate)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .onDelete { offsets in
                        let lowPriorityIndices = tasks.indices.filter { !tasks[$0].isImportant }
                        let toDelete = IndexSet(offsets.compactMap { lowPriorityIndices[$0] })
                        tasks.remove(atOffsets: toDelete)
                    }
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddSheet = true } label: {
                        Label("Add Task", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NavigationStack {
                    Form {
                        Section("New Task") {
                            TextField("Title", text: $newTitle)
                            Toggle("Important", isOn: $newIsImportant)
                            Toggle("Set due date", isOn: $useDueDate)
                            if useDueDate {
                                DatePicker("Due", selection: Binding(get: { newDueDate ?? Date() }, set: { newDueDate = $0 }), displayedComponents: [.date, .hourAndMinute])
                            }
                        }
                    }
                    .navigationTitle("Add Task")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                showingAddSheet = false
                                newTitle = ""
                                newIsImportant = false
                                newDueDate = nil
                                useDueDate = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                let task = TaskItem(title: newTitle.isEmpty ? "Untitled" : newTitle, isDone: false, isImportant: newIsImportant, dueDate: useDueDate ? newDueDate : nil)
                                tasks.append(task)
                                showingAddSheet = false
                                newTitle = ""
                                newIsImportant = false
                                newDueDate = nil
                                useDueDate = false
                            }.disabled(newTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

