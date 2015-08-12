//
//  ClientParameters.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 25-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation

public class ClientParameters: Equatable {
    public var wantParticles: Bool
    public var want1inEveryXParticles: Int
    
    public var mapType: MapType
    
    public init() {
        wantParticles = true
        want1inEveryXParticles = 200
        mapType = MapType.Floor
    }
    
    public init(dictionary: NSDictionary) {
        self.wantParticles = dictionary["wantParticles"] as! Bool
        self.want1inEveryXParticles = dictionary["want1inEveryXParticles"] as! Int
        
        self.mapType = dictionary["mapType"] as! MapType
    }
    
    public func toDictionary() -> [String : String] {
        return [
            "wantParticles": "\(wantParticles)",
            "want1inEveryXParticles": "\(want1inEveryXParticles)",
            "mapType": "\(mapType.rawValue)"
        ]
    }
}

public func ==(lhs: ClientParameters, rhs: ClientParameters) -> Bool {
    return (lhs.wantParticles == rhs.wantParticles &&
            lhs.want1inEveryXParticles == rhs.want1inEveryXParticles &&
            lhs.mapType == rhs.mapType)
}