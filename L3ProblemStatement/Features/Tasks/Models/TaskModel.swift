import Foundation

struct TaskModel: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool
    let dueDate: String?
    let priority: Priority? = .Low

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed, dueDate, priority
    }
}

enum Priority: String, Codable {
    case High = "High"
    case Low = "Low"

}

enum TaskFilter {
    case all
    case completed
    case pending
}
