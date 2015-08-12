//
//  Cell.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 25-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation
import UIKit

public class Cell: Rectangle, Equatable {
    public let name: String
    
    public init(name: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.name = name
        
        super.init(x: x, y: y, width: width, height: height)
    }
    
    public override init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as! String
        super.init(dictionary: dictionary)
    }
}

public func == (lhs: Cell, rhs: Cell) -> Bool {
    return lhs.name == rhs.name
}