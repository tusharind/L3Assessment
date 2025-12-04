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
            print("Login attempt for: \(email), found \(users.count) users")

            if let user = users.first {
                print(
                    "User found: \(user.email ?? ""), password match: \(user.password == password)"
                )
                if user.password == password {
                    isAuthenticated = true
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(email, forKey: "userEmail")
                } else {
                    errorMessage = "Incorrect password"
                }
            } else {
                errorMessage = "User not found"
                print("No user found with email: \(email)")
            }
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
            print("Login error: \(error)")
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
            let existingUsers = try context.fetch(fetchRequest)
            print("Existing users count: \(existingUsers.count)")

            for user in existingUsers {
                print("User: \(user.email ?? "no email")")
            }
            let newUser = Users(context: context)

            newUser.email = "tushar@gmail.com"
            newUser.password = "tushar@123"
            persistence.saveContext()
        } catch {
            print("Failed to seed user: \(error)")
        }
    }
}
