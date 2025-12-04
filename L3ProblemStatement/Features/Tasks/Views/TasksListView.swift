import SwiftUI

struct TasksListView: View {

    @StateObject private var viewModel = TasksListVM()
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Button("Retry") {
                            Task {
                                await viewModel.fetchTasks()
                            }
                        }
                        .font(.caption)
                        .buttonStyle(.borderless)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                }

                ZStack {
                    if viewModel.isLoading && viewModel.tasks.isEmpty {
                        ProgressView("Loading tasks...")
                    } else if viewModel.tasks.isEmpty {
                        VStack(spacing: 16) {

                            Text("no tasks fouund")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.tasks, id: \.id) { task in
                                    TaskRowView(
                                        task: task,
                                        isLocal: viewModel.isLocalTask(taskId: task.id),
                                        onToggle: {
                                            viewModel.toggleTaskStatus(taskId: task.id)
                                        }
                                    )
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
}

#Preview {
    TasksListView()
}


