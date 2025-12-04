import SwiftUI

struct TaskRowView: View {
    let task: TaskModel
    let isLocal: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Button(action: {
                if isLocal {
                    onToggle()
                }
            }) {
                Image(
                    systemName: task.completed ? "checkmark.circle.fill" : "circle"
                )
                .font(.system(size: 24))
                .foregroundColor(task.completed ? .green : .gray.opacity(0.5))
            }
            .disabled(!isLocal)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(task.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if isLocal {
                        Image(systemName: "internaldrive")
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }

                HStack(spacing: 12) {
                    if let dueDate = task.dueDate, !dueDate.isEmpty {
                        Label(formatDate(dueDate), systemImage: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    if let priority = task.priority {
                        Text(priority.rawValue)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(priorityColor(priority).opacity(0.15))
                            .foregroundColor(priorityColor(priority))
                            .cornerRadius(6)
                    }
                }
            }

            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .opacity(isLocal ? 1.0 : 0.7)
    }

    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString
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
