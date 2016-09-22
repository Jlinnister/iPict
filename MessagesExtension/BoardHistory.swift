//
//  BoardHistory.swift
//  iPict
//
//  Created by Jeff Lin on 22/09/2016.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation

struct BoardHistory {
    // MARK: Properties
    
    private static let maximumHistorySize = 10
    
    private static let userDefaultsKey = "boards"
    
    /// An array of previously created `IceCream`s.
    fileprivate var boards: [Board]
    
    var count: Int {
        return boards.count
    }
    
    subscript(index: Int) -> Board {
        return boards[index]
    }
    
    // MARK: Initialization
    
    /**
     `IceCreamHistory`'s initializer is marked as private. Instead instances should
     be loaded via the `load` method.
     */
    private init(boards: [Board]) {
        self.boards = boards
    }
    
    /// Loads previously created `IceCream`s and returns a `IceCreamHistory` instance.
//    static func load() -> BoardHistory {
//        var boards = [Board]()
//        let defaults = UserDefaults.standard
//        
//        if let savedBoards = defaults.object(forKey: BoardHistory.userDefaultsKey) as? [String] {
//            boards = savedBoards.flatMap { urlString in
//                guard let url = URL(string: urlString) else { return nil }
//                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else { return nil }
//                
//                return Board(queryItems: queryItems)
//            }
//        }
//        
//        return BoardHistory(boards: boards)
//    }
    
    /// Saves the history.
//    func save() {
//        // Save a maximum number ice creams.
//        let boardsToSave = boards.suffix(BoardHistory.maximumHistorySize)
//        
//        // Map the ice creams to an array of URL strings.
//        let iceCreamURLStrings: [String] = iceCreamsToSave.flatMap { iceCream in
//            var components = URLComponents()
//            components.queryItems = iceCream.queryItems
//            
//            return components.url?.absoluteString
//        }
//
//    }

}



/**
 Extends `IceCreamHistory` to conform to the `Sequence` protocol so it can be used
 in for..in statements.
 */
extension BoardHistory: Sequence {
    typealias Iterator = AnyIterator<Board>
    
    func makeIterator() -> Iterator {
        var index = 0
        
        return Iterator {
            guard index < self.boards.count else { return nil }
            
            let board = self.boards[index]
            index += 1
            
            return board
        }
    }
}
