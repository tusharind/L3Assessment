import SwiftUI

struct TasksListView: View {

    @StateObject private var viewModel = TasksListVM()

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
                    List(viewModel.tasks, id: \.id) { task in
                        TaskRowView(task: task)
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showAddSheet = true
                    }) {
                        Image(systemName: "plus")
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
        HStack(alignment: .top, spacing: 12) {

            VStack(alignment: .leading, spacing: 12) {
                Image(
                    systemName: task.completed
                        ? "checkmark.circle.fill" : "circle"
                )
                .foregroundColor(task.completed ? .green : .gray)
                .font(.title3)

                Text(task.title)
                    .font(.body)
                    .foregroundColor(.primary)

            }
            Spacer()
            VStack(spacing:40) {

                Text("Due: \(task.dueDate ?? "")")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("\(task.priority ?? .Low)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

        }

    }
}

#Preview {
    TasksListView()
}
