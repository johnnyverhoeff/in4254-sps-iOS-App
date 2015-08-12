//
//  Rectangle.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 25-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation
import UIKit

public class Rectangle {
    public let x: CGFloat
    public let y: CGFloat
    
    public let width: CGFloat
    public let height: CGFloat
    
    public init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.x = x
        self.y = y
        
        self.width = width
        self.height = height
    }
    
    public init(dictionary: NSDictionary) {
        let point = dictionary["point"] as! NSDictionary
        
        self.x = point["x"] as! CGFloat
        self.y = point["y"] as! CGFloat
        
        self.width = dictionary["width"] as! CGFloat
        self.height = dictionary["height"] as! CGFloat
    }
    
    public func getCGRect() -> CGRect {
        return CGRect(x: self.x, y: self.y, width: self.width, height: self.height)
    }
}
