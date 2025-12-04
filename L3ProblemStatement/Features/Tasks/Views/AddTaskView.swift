import SwiftUI

struct AddTaskView: View {

    @ObservedObject var viewModel: TasksListVM
    @Environment(\.dismiss) var dismiss

    @State private var title: String = ""
    @State private var priority: Priority = .Low
    @State private var dueDate: Date = Date()
    @State private var hasDueDate: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)

                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(Priority.Low)
                        Text("High").tag(Priority.High)
                    }
                    .pickerStyle(.segmented)
                }

                Section(header: Text("Due Date")) {
                    Toggle("Set Due Date", isOn: $hasDueDate)

                    if hasDueDate {
                        DatePicker(
                            "Due Date",
                            selection: $dueDate,
                            displayedComponents: .date
                        )
                    }
                }
            }
            .navigationTitle("Add Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTask()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }

    private func saveTask() {
        viewModel.addNewTask(
            title: title,
            priority: priority,
            dueDate: hasDueDate ? dueDate : nil
        )
        dismiss()
    }
}
