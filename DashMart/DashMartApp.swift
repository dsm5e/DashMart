//
//  DashMartApp.swift
//  DashMart
//
//  Created by dsm 5e on 14.04.2024.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct DashMartApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .onAppear {
                    UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.left")
                    UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
                    // to make system alerts and pickers use light mode only
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else {
                        return
                    }
                    window.overrideUserInterfaceStyle =  .light
                }
        }
        .onChange(of: scenePhase) {
            phase in
            
            switch phase {
            case .background, .inactive:
                Task {
                    try? await StorageService.shared.save()
                }
            default:
                break
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
