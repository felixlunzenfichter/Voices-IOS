//
//  Voice+CoreDataProperties.swift
//  Voices IOS
//
//  Created by Felix Lunzenfichter on 30.09.20.
//  Copyright © 2020 Felix Lunzenfichter. All rights reserved.
//
//

import Foundation
import CoreData


extension Voice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Voice> {
        return NSFetchRequest<Voice>(entityName: "Voice")
    }

    @NSManaged public var url: URL?
    @NSManaged public var transcript: String?
    @NSManaged public var time: Date?

}

extension Voice : Identifiable {

}
