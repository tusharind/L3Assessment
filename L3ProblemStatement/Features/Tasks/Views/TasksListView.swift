import SwiftUI

struct TasksListView: View {

    @StateObject private var viewModel = TasksListVM()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.loadingState.errorMessage {
                    HStack {
                        Text(errorMessage)

                        Spacer()
                        Button("Retry") {
                            Task {
                                await viewModel.fetchTasks()
                            }
                        }

                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                }

                Picker("Filter", selection: $viewModel.selectedFilter) {
                    Text("All").tag(TaskFilter.all)
                    Text("Completed").tag(TaskFilter.completed)
                    Text("Pending").tag(TaskFilter.pending)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                ZStack {
                    if viewModel.loadingState.isLoading
                        && viewModel.tasks.isEmpty
                    {
                        ProgressView("Loading tasks...")
                    } else if viewModel.filteredTasks.isEmpty {
                        VStack(spacing: 16) {

                            Text(
                                viewModel.tasks.isEmpty
                                    ? "No tasks found"
                                    : "No \(filterText()) tasks"
                            )
                            .foregroundColor(.secondary)
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.filteredTasks, id: \.id) {
                                    task in
                                    NavigationLink(
                                        destination: TaskDetailView(
                                            task: task,
                                            isLocal: viewModel.isLocalTask(
                                                taskId: task.id
                                            ),
                                            onDelete: {
                                                viewModel.deleteTask(
                                                    taskId: task.id
                                                )
                                            },
                                            onToggle: {
                                                viewModel.toggleStatusOfTask(
                                                    taskId: task.id
                                                )
                                            }
                                        )
                                    ) {
                                        TaskRowView(
                                            task: task,
                                            isLocal: viewModel.isLocalTask(
                                                taskId: task.id
                                            ),
                                            onToggle: {
                                                viewModel.toggleStatusOfTask(
                                                    taskId: task.id
                                                )
                                            }
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding()
                        }
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

    private func filterText() -> String {
        switch viewModel.selectedFilter {
        case .all:
            return "all"
        case .completed:
            return "completed"
        case .pending:
            return "pending"
        }
    }
}

#Preview {
    TasksListView()
}
