//
//  ParticleFilter.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 25-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation

public class ParticleFilter {
    public var particles: [Point]
    public var walkedPath: [Point]
    public var probableCellLocation: (Cell, Double)
    
    public init(dictionary: NSDictionary) {
        particles = [Point]()
        if let particlesDict = dictionary["particles"] as? [NSDictionary] {
            for particleDict in particlesDict {
                particles.append(Point(dictionary: particleDict))
            }
        }
        
        walkedPath = [Point]()
        if let walkedPathDict = dictionary["walked_path"] as? [NSDictionary] {
            for walkedPoint in walkedPathDict {
                walkedPath.append(Point(dictionary: walkedPoint))
            }
        }
        
        let probCellDict = dictionary["prob_cell_location"] as! NSDictionary
        let cellDict = probCellDict["value0"] as! NSDictionary
        let prob = probCellDict["value1"] as! Double
        
        probableCellLocation = (Cell(dictionary: cellDict), prob)
    }
}