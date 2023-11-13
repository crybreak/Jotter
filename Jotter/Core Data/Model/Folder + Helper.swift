//
//  Folder + Helper.swift
//  Jotter
//
//  Created by macbook on 10/11/2023.
//
//
import Foundation
import CoreData

extension Folder {
    
    var name: String {
        get {self.name_ ?? ""}
        set {self.name_ = newValue}
    }
    
    convenience init (name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }
    
    public override func awakeFromInsert() {
        self.creationDate = Date() + TimeInterval()
    }
    
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Folder> {
        
        let request = NSFetchRequest<Folder>(entityName: "Folder")
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Folder.creationDate, ascending: true)]
        request.predicate = predicate
        return request
    }
    
    static func delete(_ folder: Folder) {
        
        guard let context = folder.managedObjectContext else {return}
        context.delete(folder)
    }
}
