//
//  PersistentContainer.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 30.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//

import UIKit
import CoreData

class PersistentContainer: NSPersistentContainer {
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
