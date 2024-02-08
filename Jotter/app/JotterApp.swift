//
//  JotterApp.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import SwiftUI
import CoreData

@main
struct JotterApp: App {
    @Environment(\.scenePhase) var scenePhase
    #if os(OSX)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    #endif

    @AppStorage(wrappedValue: false, AppStorageKeys.showMenuBarExtra)var showMenuBar: Bool
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        MainWindow()
    
        #if os(iOS)
        .onChange(of: scenePhase) {newScenePhase in
            if  newScenePhase == .background {
                print("➡️ main app - background")
                persistenceController.save()
            }
        }
        #endif
        
        NoteWindow()
        
        #if os(OSX)
        
        Settings {
           SettingView()
        }
        
        MenuBarExtra(isInserted: $showMenuBar) {
            MenuBarExtraContentView()
        } label: {
            Label("Jotter Menu Bar Extra", systemImage: "1.circle")
        }
//        .menuBarExtraStyle(.window)
        #endif
    }
}

#if os(OSX)

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("➡️ AppDelegate - applicationDidFinishLaunching")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("➡️ AppDelegate - applicationWillTerminate")
        PersistenceController.shared.save()

    }
    
    func applicationDidResignActive(_ notification: Notification) {
        print("➡️ AppDelegate - applicationDidResignActive")
        PersistenceController.shared.save()

    }
}
#endif

