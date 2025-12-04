import SwiftUI

struct TasksListView: View {

    @StateObject private var viewModel = TasksListVM()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading tasks...")
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Text("Error")
                            .font(.headline)
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task {
                                await viewModel.fetchTasks()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.tasks, id: \.id) { task in
                                TaskRowView(task: task)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        HStack(spacing: 4) {
                            Image(
                                systemName: "rectangle.portrait.and.arrow.right"
                            )
                            Text("Logout")
                        }
                        .foregroundColor(.red)
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showAddSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.blue)
                    }
                }
            }
            .task {
                await viewModel.fetchTasks()
            }
            .refreshable {
                await viewModel.fetchTasks()
            }
            .sheet(isPresented: $viewModel.showAddSheet) {
                AddTaskView(viewModel: viewModel)
            }
        }
    }
}

struct TaskRowView: View {
    let task: TaskModel

    var body: some View {
        HStack(spacing: 16) {
            Image(
                systemName: task.completed ? "checkmark.circle.fill" : "circle"
            )
            .font(.system(size: 24))
            .foregroundColor(task.completed ? .green : .gray.opacity(0.5))

            VStack(alignment: .leading, spacing: 6) {
                Text(task.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)

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

#Preview {
    TasksListView()
}
