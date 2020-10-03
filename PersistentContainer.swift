//
//  PersistentContainer.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 30.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import CoreData

protocol ContentUpdateDelegate {
    func refreshList()
}

class PersistentContainer: NSPersistentContainer {
    
    var listViewDelegate : ContentUpdateDelegate!
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
    func saveVoice(voiceName: String) {
        let voice = Voice(context: self.viewContext)
        voice.title = voiceName
        voice.filename = voiceName
        do {
            try self.viewContext.save()
        } catch {
            print(error)
        }
        listViewDelegate.refreshList()
    }
    
    func deleteVoice(voice: Voice) {
        viewContext.delete(voice)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        listViewDelegate.refreshList()
    }
}


