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
        self.name_ = name
    }
    
    public override func awakeFromInsert() {
        self.creationDate = Date() + TimeInterval()
    }
}
