//
//  Note+Helper.swift
//  Jotter
//
//  Created by macbook on 07/11/2023.
//

import Foundation
import CoreData

extension Note {
    var title: String {
        get {
            self.title_ ?? ""
        } set (newValue) {
            self.title_ = newValue
        }
    }
    
    convenience init(title: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
    }
    
    public override func awakeFromInsert() {
        self.creationDate = Date() + TimeInterval()
    }
    
    static func fetch(_ predicate: NSPredicate ) -> NSFetchRequest<Note> {
        let request = NSFetchRequest<Note>(entityName: "Note")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Note.creationDate, ascending: true)]
        request.predicate = predicate
        return request
    }
}
