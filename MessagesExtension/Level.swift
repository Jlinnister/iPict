//
//  Level.swift
//  iPict
//
//  Created by Jim Wang on 9/20/16.
//  Copyright © 2016 iPict. All rights reserved.
//

import Foundation

struct Level {
    let answer: [NSArray]


init(levelNumber: Int) {
    let fileName = "map.plist"
    let levelPath = "\(Bundle.main.resourcePath!)/\(fileName)"
    
    let levelDictionary: NSDictionary? = NSDictionary(contentsOfFile: levelPath)
    
    self.answer = levelDictionary!["answer"] as! [NSArray]
 }
}
