import CoreData
import SwiftUI

@MainActor
class TasksListVM: ObservableObject {

    @Published var tasks: [TaskModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showAddSheet: Bool = false

    private let networkClient: NetworkClientProtocol
    private let persistence: PersistenceController
    private let baseURL = "https://jsonplaceholder.typicode.com"

    init(
        networkClient: NetworkClientProtocol = AppContainer.shared
            .networkClient,
        persistence: PersistenceController = AppContainer.shared.persistence
    ) {
        self.networkClient = networkClient
        self.persistence = persistence
    }

    func fetchTasks() async {

        loadLocalTasks()

        isLoading = true
        errorMessage = nil

        let endpoint = Endpoint(
            path: "/todos",
            method: .GET
        )

        do {
            let fetchedTasks: [TaskModel] = try await networkClient.request(
                endpoint,
                baseURL: baseURL
            )
            let localTasks = tasks
            tasks = localTasks + fetchedTasks
        } catch let error as NetworkError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "An unexpected error occurred"
        }

        isLoading = false
    }

    func addTask(title: String, priority: Priority, dueDate: Date?) {
        let context = persistence.context
        let taskEntity = TaskEntity(context: context)

        taskEntity.id = Int64(Date().timeIntervalSince1970)
        taskEntity.title = title
        taskEntity.completed = false
        taskEntity.priority = priority.rawValue
        taskEntity.userID = 1

        if let dueDate = dueDate {
            let formatter = ISO8601DateFormatter()
            taskEntity.dueDate = formatter.string(from: dueDate)
        }

        persistence.saveContext()

        let newTask = TaskModel(
            userID: Int(taskEntity.userID),
            id: Int(taskEntity.id),
            title: taskEntity.title ?? "",
            completed: taskEntity.completed,
            dueDate: taskEntity.dueDate
        )

        tasks.insert(newTask, at: 0)
    }

    func loadLocalTasks() {
        let context = persistence.context
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()

        do {
            let entities = try context.fetch(fetchRequest)

            let localTasks = entities.map { entity in
                TaskModel(
                    userID: Int(entity.userID),
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    completed: entity.completed,
                    dueDate: entity.dueDate
                )
            }
            tasks = localTasks
        } catch {
            print("Failed to load local tasks: \(error)")
        }
    }
    
    func toggleTaskStatus(taskId: Int) {
        let context = persistence.context
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", taskId)
        
        do {
            let entities = try context.fetch(fetchRequest)
            
            if let taskEntity = entities.first {
                taskEntity.completed.toggle()
                persistence.saveContext()
                
                if let index = tasks.firstIndex(where: { $0.id == taskId }) {
                    let updatedTask = tasks[index]
                    tasks[index] = TaskModel(
                        userID: updatedTask.userID,
                        id: updatedTask.id,
                        title: updatedTask.title,
                        completed: !updatedTask.completed,
                        dueDate: updatedTask.dueDate,
                    )
                }
                
                print("Toggled task status for id: \(taskId)")
            }
        } catch {
            print("Failed to toggle task status: \(error)")
        }
    }
    
    func isLocalTask(taskId: Int) -> Bool {
        let context = persistence.context
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", taskId)
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
}
 


