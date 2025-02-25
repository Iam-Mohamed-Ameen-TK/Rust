//
//  ProjectExampleApp.swift
//  ProjectExample
//
//  Created by Mohamed Ameen on 28/12/24.
//

import SwiftUI
import UIKit
import SwiftData
import Firebase

@main
struct ProjectExampleApp: App {
    @StateObject private var notificationManager = NotificationManager()
    @StateObject private var modelContext = ModelContext()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(notificationManager)
                .modelContainer(for: [Recipe.self,Profile.self])
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

class ModelContext: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var profiles: [Profile] = []
}

//import SwiftUI
//import UIKit
//import SwiftData
//import Firebase
//
//@main
//struct ProjectExampleApp: App {
//    // ✅ Create a shared data model
//    @StateObject private var modelContext = ModelContext()
//
//    // ✅ Ensure AppDelegate manages Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    var body: some Scene {
//        WindowGroup {
//            SplashScreen()
//                .environmentObject(modelContext) // Inject modelContext globally
//                .modelContainer(for: [Recipe.self, Profile.self]) // SwiftData models
//        }
//    }
//}
//
//// ✅ AppDelegate handles Firebase setup
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
//
//// ✅ ModelContext to manage Recipe & Profile data
//class ModelContext: ObservableObject {
//    @Published var recipes: [Recipe] = []
//    @Published var profiles: [Profile] = []
//
//    init() {
//        loadData()
//    }
//
//    /// Function to load initial data
//    func loadData() {
//        // 🔹 Placeholder for loading from SwiftData (replace with real data fetch)
//        recipes = []
//        profiles = []
//    }
//
//    /// Function to add a new recipe
//    func addRecipe(_ recipe: Recipe) {
//        recipes.append(recipe)
//        saveData()
//    }
//
//    /// Function to add a new profile
//    func addProfile(_ profile: Profile) {
//        profiles.append(profile)
//        saveData()
//    }
//
//    /// Function to save changes (Replace with actual SwiftData logic)
//    func saveData() {
//        // 🔹 Save changes to SwiftData (implement actual save logic here)
//        print("Data saved successfully!")
//    }
//}
