//
//  Point.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 25-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation
import UIKit

public class Point {
    public let x: CGFloat
    public let y: CGFloat
    
    public let size: CGFloat = 1.0
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
    
    public init(dictionary: NSDictionary) {
        self.x = dictionary["x"] as! CGFloat
        self.y = dictionary["y"] as! CGFloat
    }
    
    public func getCGRect() -> CGRect {
        return CGRect(x: self.x, y: self.y, width: self.size, height: self.size)
    }
}