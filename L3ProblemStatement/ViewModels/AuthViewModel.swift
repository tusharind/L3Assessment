import CoreData
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {

    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let persistence: PersistenceController

    init(persistence: PersistenceController = AppContainer.shared.persistence) {
        self.persistence = persistence
        seedingUser()
    }

    func login(email: String, password: String) {
        isLoading = true
        errorMessage = nil

        let context = persistence.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)

        do {
            let users = try context.fetch(fetchRequest)

            if let user = users.first {
                if user.password == password {
                    isAuthenticated = true
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                } else {
                    errorMessage = "Incorrect password"
                }
            } else {
                errorMessage = "User not found"
            }
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func logout() {
        isAuthenticated = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "userEmail")
    }

    func checkAuthenticationStatus() {
        isAuthenticated = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }

    private func seedingUser() {
        let context = persistence.context
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()

        do {
            let count = try context.count(for: fetchRequest)

            if count == 0 {
                let defaultUser = Users(context: context)
                let newUser = Users(context: context)

                defaultUser.email = "admin@test.com"
                defaultUser.password = "password123"
                newUser.email = "tushar@gmail.com"
                newUser.password = "tushar@123"
                persistence.saveContext()
            }
        } catch {
            print("Failed to seed user: \(error)")
        }
    }
}

