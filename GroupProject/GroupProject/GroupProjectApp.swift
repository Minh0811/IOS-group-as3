//
//  GroupProjectApp.swift
//  GroupProject
//
//  Created by Khanh, Tran Huy on 10/09/2023.
//

import SwiftUI
import Firebase


@main
struct GroupProjectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationView{
                AuthenticationView()
            }
        }
    }
}
class AppDelegate: NSObject,UIApplicationDelegate{
       
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
           
        FirebaseApp.configure()
        return true
    }
}
