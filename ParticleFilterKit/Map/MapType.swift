//
//  MapType.swift
//  SocketIOJsonTestApp
//
//  Created by Johnny Verhoeff on 25-07-15.
//  Copyright (c) 2015 Johnny Verhoeff. All rights reserved.
//

import Foundation

public enum MapType : String {
    case Floor = "Floor"
    case Bluetooth = "Bluetooth"
    case FloorWithBluetooth = "FloorWithBluetooth"
    case EntireFloor = "EntireFloor"
    case EntireFloorWithBluetooth = "EntireFloorWithBluetooth"
    
    public static let mapTypes: [MapType] = [.Floor, .Bluetooth, .FloorWithBluetooth, .EntireFloor, .EntireFloorWithBluetooth]
    
    public static func fromString(string: String) -> MapType {
        for mapType in MapType.mapTypes {
            if mapType.rawValue == string {
                return mapType
            }
        }
        return MapType.Floor
    }
}