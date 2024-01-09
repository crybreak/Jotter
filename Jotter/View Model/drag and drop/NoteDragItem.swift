//
//  NoteDragItem.swift
//  Jotter
//
//  Created by Wilfried Mac Air on 09/01/2024.
//

import Foundation
import UniformTypeIdentifiers

class NoteDragItem: NSObject, Codable{
    var id: UUID?
    
    required init(id: UUID? = nil) {
        self.id = id
    }
    
    required init(_ info: NoteDragItem) {
        self.id = info.id
        super.init()
    }
}


// make it draggle

extension NoteDragItem: NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [UTType.jotterNote.identifier]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping @Sendable (Data?, Error?) -> Void) -> Progress? {
        
        let progress = Progress(totalUnitCount: 100)
        do {
            let coder = JSONEncoder()
            let myJSON = try coder.encode(self)
            progress.completedUnitCount = 100
            completionHandler(myJSON, nil)
            
        } catch {
            print("error \(error.localizedDescription)")
            completionHandler(nil, error)
        }
        
        return progress
    }
    
    
}

//make it droppable

extension NoteDragItem: NSItemProviderReading    {
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [UTType.jotterNote.identifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        
        do {
            let item = try decoder.decode(NoteDragItem.self, from: data)
            return self.init(item)
        } catch  {
            throw error
        }
        
        
    }
    
    
}
