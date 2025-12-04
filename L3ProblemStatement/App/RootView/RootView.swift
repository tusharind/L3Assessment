import SwiftUI

struct RootView: View {
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                TasksListView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
        .onAppear {
            authViewModel.isUserLoggedIn()
        }
    }
}

#Preview {
    RootView()
}



