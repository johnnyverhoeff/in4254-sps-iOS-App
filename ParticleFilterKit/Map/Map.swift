//
//  Map.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 25-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation
import UIKit

public class Map {
    public let width: CGFloat
    public let height: CGFloat
    
    public let mapType: String
    
    public var obstacles: [Rectangle]
    public var cells: [Cell]
    
    public init(dictionary: NSDictionary) {
        
        width = dictionary["width"] as! CGFloat
        height = dictionary["height"] as! CGFloat

        mapType = dictionary["mapType"] as! String
        
        cells = [Cell]()
        if let cellsDict = dictionary["cells"] as? [NSDictionary] {
            for c in cellsDict {
                self.cells.append(Cell(dictionary: c))
            }
        }
        
        obstacles = [Rectangle]()
        if let obstaclesDict = dictionary["obstacles"] as? [NSDictionary] {
            for obs in obstaclesDict {
                self.obstacles.append(Rectangle(dictionary: obs))
            }
        } 
    }
    
    public func getCGRect() -> CGRect {
        return CGRect(x: 0, y: 0, width: self.width, height: self.height)
    }
    
    public func getWidthDependingOnRotation(rotation: Bool) -> CGFloat {
        return rotation ? self.height : self.width
    }
    
    public func getHeightDependingOnRotation(rotation: Bool) -> CGFloat {
        return rotation ? self.width : self.height
    }
}