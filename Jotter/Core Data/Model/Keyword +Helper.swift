//
//  KeywordClass +Helper.swift
//  Jotter
//
//  Created by macbook on 09/11/2023.
//

import SwiftUI
import CoreData

extension Keyword {

    var uuid: UUID  {
        #if DEBUG
        uuid_!
        #else
        self.uuid_ ?? UUID()
        #endif
    }
    
    var name: String {
        get { self.name_ ?? ""}
        set{ self.name_ = newValue}
    }
    var colorHex: Color {
        get {
            if let colorHexValue = self.colorHex_,
               let color = Color(hex: colorHexValue) {
                return color
            } else {
                return Color.black
            }
        } set {
            self.colorHex_ = newValue.toHex()
        }
    }
    
    var color: Color {
        get {
            Color(red: self.red_, green: self.green_, blue: self.blue_, opacity: self.opacity_)
        }
        set {
            guard let components = newValue.cgColor?.components,
                  components.count > 2 else {return}
            self.red_ = Double(components[0])
            self.green_ = Double(components[1])
            self.blue_ = Double(components[2])
            
            if (components.count == 4) {
                self.opacity_ = Double(components [3])
            } else {
                self.opacity_ = 1
            }
            
        }
    }
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }
    
    public override func awakeFromInsert() {
        self.uuid_ = UUID()
    }
    
    static func fetch(_ predicate: NSPredicate) -> NSFetchRequest<Keyword> {
        
        let request = NSFetchRequest<Keyword>(entityName: "Keyword")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Keyword.name_, ascending: true)]
        request.predicate = predicate
        
        return request
    }
    
    static func fetch(for note: Note) -> NSFetchRequest<Keyword> {
        let predicate = NSPredicate(format: "%K CONTAINS %@", KeywordProperties.notes, note)
        
        return Keyword.fetch(predicate)
    }
    
    static func delete(keyword: Keyword) {
        guard let context = keyword.managedObjectContext else {return}
        context.delete(keyword)
    }
}


struct KeywordProperties {
    static let uuid = "uuid_"

    static let name = "name_"
    static let notes = "notes_"
}


//MARK: Keyword Relationship

extension Keyword {
    
    var notes: Set<Note> {
        get { (self.notes_ as? Set<Note>) ?? [] }
        set {self.notes_ = newValue as NSSet}
    }
}

//MARK: Preview Helper

extension Keyword {
    
    static func exampleArray() -> [Keyword] {
        let context = PersistenceController.preview.container.viewContext
    
        var keys = [Keyword]()
        for index in 0..<5 {
            let key = Keyword(name: "keyword \(index)", context: context)
            let colorValue = CGFloat(index) / 5
            key.color = Color(red: colorValue, green: 0.5, blue: colorValue)
            keys.append(key)
        }
        return keys
    }
}

