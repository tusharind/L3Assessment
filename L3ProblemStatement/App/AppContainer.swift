import Foundation
import CoreData

final class AppContainer {
    
    let networkClient: NetworkClientProtocol
    let persistence: PersistenceController
    
    static let shared = AppContainer()
    
    private init() {
        let logger = LoggerInterceptor()
        self.networkClient = NetworkClient(interceptor: logger)
        self.persistence = PersistenceController.shared
    }
}


