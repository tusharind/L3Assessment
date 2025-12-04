import SwiftUI

struct TaskDetailView: View {
    let task: TaskModel
    let isLocal: Bool
    let onDelete: () -> Void
    let onToggle: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Title")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(task.title)
                        .font(.title3)
                        .foregroundColor(.primary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Status")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    HStack {

                        Text(task.completed ? "Completed" : "Pending")
                            .font(.body)
                            .foregroundColor(.primary)

                        Spacer()

                    }
                }

                if let priority = task.priority {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Priority")
                            .font(.headline)
                            .foregroundColor(.secondary)

                        HStack {
                            Text(priority.rawValue)
                                .font(.body)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)

                            Spacer()
                        }
                    }

                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Task ID")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text("\(task.id)")
                        .font(.body)
                        .foregroundColor(.primary)
                }

                HStack(alignment: .center) {

                    Spacer()

                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        HStack {

                            Text("Delete Task")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)

                    }
                    Spacer()

                }

            }
            .padding()
        }
        .navigationTitle("Task Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Task", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                onDelete()
                dismiss()
            }
        } message: {
            Text("Are you sure??")
        }
    }

    private func priorityColor(_ priority: Priority) -> Color {
        switch priority {
        case .High:
            return .red
        case .Low:
            return .blue
        }
    }
}
